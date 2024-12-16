{
  stdenv,
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  coreutils,
  runCommand,
  runtimeShell,
  writeText,
  terraform-providers,
  installShellFiles,
}:

let
  package = buildGoModule rec {
    pname = "opentofu";
    version = "1.8.7";

    src = fetchFromGitHub {
      owner = "opentofu";
      repo = "opentofu";
      rev = "v${version}";
      hash = "sha256-OLXR9aA94KcIsZxk8gOZxZsljMKuymScuYcoj9W5Hj4=";
    };

    vendorHash = "sha256-6M/uqwhNruIPx5srbimKuDJaFiZkyosoZQXWjxa6GxY=";
    ldflags = [
      "-s"
      "-w"
      "-X"
      "github.com/opentofu/opentofu/version.dev=no"
    ];

    postConfigure = ''
      # speakeasy hardcodes /bin/stty https://github.com/bgentry/speakeasy/issues/22
      substituteInPlace vendor/github.com/bgentry/speakeasy/speakeasy_unix.go \
        --replace-fail "/bin/stty" "${coreutils}/bin/stty"
    '';

    nativeBuildInputs = [ installShellFiles ];
    patches = [ ./provider-path-0_15.patch ];

    passthru = {
      inherit full plugins withPlugins;
      tests = {
        inherit opentofu_plugins_test;
      };
    };

    # https://github.com/posener/complete/blob/9a4745ac49b29530e07dc2581745a218b646b7a3/cmd/install/bash.go#L8
    postInstall = ''
      installShellCompletion --bash --name tofu <(echo complete -C tofu tofu)
    '';

    preCheck = ''
      export HOME=$TMPDIR
      export TF_SKIP_REMOTE_TESTS=1
    '';

    subPackages = [ "./cmd/..." ];

    meta = with lib; {
      description = "Tool for building, changing, and versioning infrastructure";
      homepage = "https://opentofu.org/";
      changelog = "https://github.com/opentofu/opentofu/blob/v${version}/CHANGELOG.md";
      license = licenses.mpl20;
      maintainers = with maintainers; [
        nickcao
        zowoq
      ];
      mainProgram = "tofu";
    };
  };

  full = withPlugins (p: lib.filter lib.isDerivation (lib.attrValues p.actualProviders));

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

        resource "random_id" "test" {}
      '';
      opentofu = package.withPlugins (p: [ p.random ]);
      test = runCommand "opentofu-plugin-test" { buildInputs = [ opentofu ]; } ''
        # make it fail outside of sandbox
        export HTTP_PROXY=http://127.0.0.1:0 HTTPS_PROXY=https://127.0.0.1:0
        cp ${mainTf} main.tf
        tofu init
        touch $out
      '';
    in
    test;

  plugins =
    lib.mapAttrs
      (
        _: provider:
        if provider ? override then
          # use opentofu plugin registry over terraform's
          provider.override (oldArgs: {
            provider-source-address = lib.replaceStrings [ "https://registry.terraform.io/providers" ] [
              "registry.opentofu.org"
            ] oldArgs.homepage;
          })
        else
          provider
      )
      (
        removeAttrs terraform-providers [
          "override"
          "overrideDerivation"
          "recurseForDerivations"
        ]
      );

  withPlugins =
    plugins:
    let
      actualPlugins = plugins package.plugins;

      # Wrap PATH of plugins propagatedBuildInputs, plugins may have runtime dependencies on external binaries
      wrapperInputs = lib.unique (
        lib.flatten (lib.catAttrs "propagatedBuildInputs" (builtins.filter (x: x != null) actualPlugins))
      );

      passthru = {
        withPlugins = newplugins: withPlugins (x: newplugins x ++ actualPlugins);

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
        overrideDerivation = f: (package.overrideDerivation f).withPlugins plugins;
        overrideAttrs = f: (package.overrideAttrs f).withPlugins plugins;
        override = x: (package.override x).withPlugins plugins;
      };
    in
    # Don't bother wrapping unless we actually have plugins, since the wrapper will stop automatic downloading
    # of plugins, which might be counterintuitive if someone just wants a vanilla Terraform.
    if actualPlugins == [ ] then
      package.overrideAttrs (orig: {
        passthru = orig.passthru // passthru;
      })
    else
      lib.appendToName "with-plugins" (
        stdenv.mkDerivation {
          inherit (package) meta pname version;
          nativeBuildInputs = [ makeWrapper ];

          # Expose the passthru set with the override functions
          # defined above, as well as any passthru values already
          # set on `terraform` at this point (relevant in case a
          # user overrides attributes).
          passthru = package.passthru // passthru;

          buildCommand = ''
            # Create wrappers for terraform plugins because Terraform only
            # walks inside of a tree of files.
            for providerDir in ${toString actualPlugins}
            do
              for file in $(find $providerDir/libexec/terraform-providers -type f)
              do
                relFile=''${file#$providerDir/}
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
            makeWrapper "${package}/bin/tofu" "$out/bin/tofu" \
              --set NIX_TERRAFORM_PLUGIN_DIR $out/libexec/terraform-providers \
              --prefix PATH : "${lib.makeBinPath wrapperInputs}"
          '';
        }
      );
in
package
