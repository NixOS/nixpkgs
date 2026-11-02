{
  stdenv,
  lib,
  buildGo127Module,
  fetchFromGitHub,
  makeWrapper,
  runCommand,
  versionCheckHook,
  writableTmpDirAsHomeHook,
  writeText,
  terraform-providers,
  installShellFiles,
}:

buildGo127Module (finalAttrs: {
  pname = "opentofu";
  version = "1.13.5";
  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "opentofu";
    repo = "opentofu";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OKcBYDmioqebxmU8rL8oFC0MyHOivDyc4FU2wI8uRAI=";
  };

  subPackages = [ "./cmd/..." ];

  vendorHash = "sha256-NwHu+t6GFPCGMLt9PHdz+PMAzcrUBGXwmi5vvl2NsEw=";
  ldflags = [
    "-s"
    "-w"
    "-X"
    "github.com/opentofu/opentofu/version.dev=no"
  ];

  nativeBuildInputs = [ installShellFiles ];
  patches = [ ./provider-path-1_12.patch ];

  # https://github.com/posener/complete/blob/9a4745ac49b29530e07dc2581745a218b646b7a3/cmd/install/bash.go#L8
  postInstall = ''
    installShellCompletion --bash --name tofu <(echo complete -C tofu tofu)
  '';

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
    versionCheckHook
  ];

  doInstallCheck = true;
  versionCheckProgramArg = "version";

  preCheck = ''
    export TF_SKIP_REMOTE_TESTS=1
  '';

  passthru = {
    withPlugins =
      pluginFunction:
      let
        actualPlugins = pluginFunction finalAttrs.finalPackage.plugins;

        # Wrap PATH of plugins propagatedBuildInputs, plugins may have runtime dependencies on external binaries
        wrapperInputs = lib.unique (
          lib.flatten (lib.catAttrs "propagatedBuildInputs" (builtins.filter (x: x != null) actualPlugins))
        );
      in
      # Don't bother wrapping unless we actually have plugins, since the wrapper will stop automatic downloading
      # of plugins, which might be counterintuitive if someone just wants a vanilla Terraform.
      if actualPlugins != [ ] then
        lib.appendToName "with-plugins" (
          stdenv.mkDerivation {
            inherit (finalAttrs.finalPackage)
              meta
              pname
              version
              ;
            nativeBuildInputs = [ makeWrapper ];

            buildCommand = ''
              # Create wrappers for terraform plugins because OpenTofu only
              # walks inside of a tree of files.
              # Also replace registry.terraform.io dir with registry.opentofu.org,
              # so OpenTofu can find the plugins.
              for providerDir in ${toString actualPlugins}
              do
                for file in $(find $providerDir/libexec/terraform-providers -type f)
                do
                  relFile=''${file#$providerDir/}
                  relFile=''${relFile/registry.terraform.io/registry.opentofu.org}
                  mkdir -p $out/$(dirname $relFile)
                  makeWrapper "$file" "$out/$relFile"
                done
              done

              # Create a wrapper for opentofu to point it to the plugins dir.
              mkdir -p $out/bin/
              makeWrapper "${lib.getExe finalAttrs.finalPackage}" "$out/bin/${finalAttrs.finalPackage.meta.mainProgram}" \
                --set NIX_TERRAFORM_PLUGIN_DIR $out/libexec/terraform-providers \
                --prefix PATH : "${lib.makeBinPath wrapperInputs}"
            '';
          }
        )
      else
        finalAttrs.finalPackage;
    full = finalAttrs.finalPackage.withPlugins (
      p: lib.filter lib.isDerivation (lib.attrValues p.actualProviders)
    );
    plugins = removeAttrs terraform-providers [
      "override"
      "overrideDerivation"
      "recurseForDerivations"
    ];

    tests = {
      opentofu_plugins_test =
        let
          mainTf = writeText "main.tf" ''
            terraform {
              required_providers {
                random = {
                  source  = "hashicorp/random"
                }
              }
            }

            resource "random_id" "server" {
              keepers = {
                ami_id = var.ami_id
              }

              byte_length = 8
            }
          '';
          opentofu = finalAttrs.finalPackage.withPlugins (p: [ p.hashicorp_random ]);
        in
        runCommand "opentofu-plugin-test" { buildInputs = [ opentofu ]; } ''
          cp ${mainTf} main.tf
          tofu init -backend=false -json-into=$out
        '';
    };
  };

  meta = {
    description = "Tool for building, changing, and versioning infrastructure";
    homepage = "https://opentofu.org/";
    changelog = "https://github.com/opentofu/opentofu/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      nickcao
      zowoq
    ];
    mainProgram = "tofu";
  };
})
