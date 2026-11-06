{
  stdenv,
  lib,
  buildGo127Module,
  fetchFromGitHub,
  makeWrapper,
  runCommand,
  runtimeShell,
  versionCheckHook,
  writableTmpDirAsHomeHook,
  writeText,
  terraform-providers,
  installShellFiles,
  emptyFile,
}:

let
  package = buildGo127Module rec {
    pname = "opentofu";
    version = "1.13.5";

    src = fetchFromGitHub {
      owner = "opentofu";
      repo = "opentofu";
      tag = "v${version}";
      hash = "sha256-OKcBYDmioqebxmU8rL8oFC0MyHOivDyc4FU2wI8uRAI=";
    };

    vendorHash = "sha256-NwHu+t6GFPCGMLt9PHdz+PMAzcrUBGXwmi5vvl2NsEw=";
    ldflags = [
      "-s"
      "-w"
      "-X"
      "github.com/opentofu/opentofu/version.dev=no"
    ];

    nativeBuildInputs = [ installShellFiles ];
    patches = [ ./provider-path-1_12.patch ];

    passthru = {
      inherit plugins;
      tests = {
        inherit opentofu_plugins_test;
        eval = evalTests emptyFile;
      };
    };

    # https://github.com/posener/complete/blob/9a4745ac49b29530e07dc2581745a218b646b7a3/cmd/install/bash.go#L8
    postInstall = ''
      installShellCompletion --bash --name tofu <(echo complete -C tofu tofu)
    '';

    __darwinAllowLocalNetworking = true;

    nativeCheckInputs = [
      writableTmpDirAsHomeHook
      versionCheckHook
    ];

    doInstallCheck = true;
    versionCheckProgramArg = "version";

    preCheck = ''
      export TF_SKIP_REMOTE_TESTS=1
    '';

    subPackages = [ "./cmd/..." ];

    meta = {
      description = "Tool for building, changing, and versioning infrastructure";
      homepage = "https://opentofu.org/";
      changelog = "https://github.com/opentofu/opentofu/blob/v${version}/CHANGELOG.md";
      license = lib.licenses.mpl20;
      maintainers = with lib.maintainers; [
        nickcao
        zowoq
      ];
      mainProgram = "tofu";
    };
  };

  opentofu_plugins_test =
    let
      mainTf = writeText "main.tf" ''
        terraform {
          required_providers {
            random = {
              source  = "hashicorp/random"
            }
            local = {
              source  = "hashicorp/local"
            }
          }
        }

        resource "random_id" "test" {}
        resource "local_file" "test2" {}
      '';
      opentofu =
        ((pluggable package).withPlugins (
          p:
          # If hashicorp_random were to be bundled by default and then
          # null-ed out in the package set, this test would need to switch
          # to a different provider.
          assert lib.isDerivation p.hashicorp_random;
          [ p.hashicorp_random ]
        )).withPlugins
          (
            p:
            assert lib.isDerivation p.hashicorp_local;
            [
              p.hashicorp_local
            ]
          );
      test = runCommand "opentofu-plugin-test" { buildInputs = [ opentofu ]; } ''
        # make it fail outside of sandbox
        export HTTP_PROXY=http://127.0.0.1:0 HTTPS_PROXY=https://127.0.0.1:0
        cp ${mainTf} main.tf
        tofu init
        touch $out
      '';
    in
    test;

  evalTests =
    ok:
    # overrideAttrs works on withPlugins and modifies the unwrapped derivation inside
    # See https://github.com/NixOS/nixpkgs/issues/158620
    assert
      (((pluggable package).withPlugins (p: [ p.hashicorp_random ])).overrideAttrs { name = "squee"; })
      .unwrapped.name == "squee";

    ok;

  plugins = removeAttrs terraform-providers [
    "override"
    "overrideDerivation"
    "recurseForDerivations"
  ];

  pluggable =
    opentofu:
    let
      withPlugins =
        plugins:
        let
          actualPlugins = plugins opentofu.plugins;

          # Wrap PATH of plugins propagatedBuildInputs, plugins may have runtime dependencies on external binaries
          wrapperInputs = lib.unique (
            lib.flatten (lib.catAttrs "propagatedBuildInputs" (builtins.filter (x: x != null) actualPlugins))
          );

          passthru = {
            withPlugins = newplugins: withPlugins (x: newplugins x ++ actualPlugins);
            full = withPlugins (p: lib.filter lib.isDerivation (lib.attrValues p.actualProviders));

            # Expose wrappers around the override* functions of the terraform
            # derivation.
            #
            # Note that this does not behave as anyone would expect if plugins
            # are specified. The overrides are not on the user-visible wrapper
            # derivation but instead on the function application that eventually
            # generates the wrapper. This means:
            #
            # 1. When using overrideAttrs, only `passthru` attributes will
            #    become visible on the wrapper derivation. Other overrides that
            #    modify the derivation *may* still have an effect, but it can be
            #    difficult to follow.
            #
            # 2. Other overrides may work if they modify the terraform
            #    derivation, or they may have no effect, depending on what
            #    exactly is being changed.
            #
            # 3. Specifying overrides on the wrapper is unsupported.
            #
            # See nixpkgs#158620 for details.
            overrideAttrs = f: (pluggable (opentofu.overrideAttrs f)).withPlugins plugins;

            # It could be supported by getting the opentofu attribute through
            # callPackage instead, but that wouldn't solve the undoing of
            # overrideAttrs anyway.
            # Until we have https://github.com/NixOS/nixpkgs/issues/273815, we're
            # better off requiring override to go first and save the user
            # potential headaches.
            override = abort "(opentofu.withPlugins ...).override is not supported. Call .override before calling any other attributes.";
            # Similarly, except overrideDerivation is on the way out.
            overrideDerivation = abort "(opentofu.withPlugins ...).overrideDerivation is not supported. Use overrideAttrs instead.";

            /**
              The opentofu package before pinning the plugins with `withPlugins`
            */
            unwrapped = opentofu;
          };
        in
        # Don't bother wrapping unless we actually have plugins, since the wrapper will stop automatic downloading
        # of plugins, which might be counterintuitive if someone just wants a vanilla Terraform.
        if actualPlugins == [ ] then
          opentofu.overrideAttrs (orig: {
            passthru = orig.passthru // passthru;
          })
        else
          lib.appendToName "with-plugins" (
            stdenv.mkDerivation {
              inherit (opentofu) meta pname version;
              nativeBuildInputs = [ makeWrapper ];

              # Expose the passthru set with the override functions
              # defined above, as well as any passthru values already
              # set on `terraform` at this point (relevant in case a
              # user overrides attributes).
              passthru = opentofu.passthru // passthru;

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
                    cat <<WRAPPER > $out/$relFile
                #!${runtimeShell}
                exec "$file" "$@"
                WRAPPER
                    chmod +x $out/$relFile
                  done
                done

                # Create a wrapper for opentofu to point it to the plugins dir.
                mkdir -p $out/bin/
                makeWrapper "${opentofu}/bin/tofu" "$out/bin/tofu" \
                  --set NIX_TERRAFORM_PLUGIN_DIR $out/libexec/terraform-providers \
                  --prefix PATH : "${lib.makeBinPath wrapperInputs}"
              '';
            }
          );
    in
    withPlugins (_: [ ]);
in
pluggable package
