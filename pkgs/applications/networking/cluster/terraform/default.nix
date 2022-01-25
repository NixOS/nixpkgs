{ stdenv
, lib
, buildEnv
, buildGoModule
, fetchFromGitHub
, makeWrapper
, coreutils
, runCommand
, runtimeShell
, writeText
, terraform-providers
, fetchpatch
}:

let
  generic = { version, sha256, vendorSha256 ? null, ... }@attrs:
    let attrs' = builtins.removeAttrs attrs [ "version" "sha256" "vendorSha256" ];
    in
    buildGoModule ({
      name = "terraform-${version}";

      inherit vendorSha256;

      src = fetchFromGitHub {
        owner = "hashicorp";
        repo = "terraform";
        rev = "v${version}";
        inherit sha256;
      };

      ldflags = [ "-s" "-w" ];

      postConfigure = ''
        # speakeasy hardcodes /bin/stty https://github.com/bgentry/speakeasy/issues/22
        substituteInPlace vendor/github.com/bgentry/speakeasy/speakeasy_unix.go \
          --replace "/bin/stty" "${coreutils}/bin/stty"
      '';

      postInstall = ''
        # remove all plugins, they are part of the main binary now
        for i in $out/bin/*; do
          if [[ $(basename $i) != terraform ]]; then
            rm "$i"
          fi
        done
      '';

      preCheck = ''
        export HOME=$TMPDIR
        export TF_SKIP_REMOTE_TESTS=1
      '';

      subPackages = [ "." ];

      meta = with lib; {
        description =
          "Tool for building, changing, and versioning infrastructure";
        homepage = "https://www.terraform.io/";
        changelog = "https://github.com/hashicorp/terraform/blob/v${version}/CHANGELOG.md";
        license = licenses.mpl20;
        maintainers = with maintainers; [
          Chili-Man
          babariviere
          kalbasit
          marsam
          maxeaubrey
          timstott
          zimbatm
          zowoq
        ];
      };
    } // attrs');

  pluggable = terraform:
    let
      withPlugins = plugins:
        let
          actualPlugins = plugins terraform.plugins;

          # Wrap PATH of plugins propagatedBuildInputs, plugins may have runtime dependencies on external binaries
          wrapperInputs = lib.unique (lib.flatten
            (lib.catAttrs "propagatedBuildInputs"
              (builtins.filter (x: x != null) actualPlugins)));

          passthru = {
            withPlugins = newplugins:
              withPlugins (x: newplugins x ++ actualPlugins);
            full = withPlugins (p: lib.filter lib.isDerivation (lib.attrValues p));

            # Ouch
            overrideDerivation = f:
              (pluggable (terraform.overrideDerivation f)).withPlugins plugins;
            overrideAttrs = f:
              (pluggable (terraform.overrideAttrs f)).withPlugins plugins;
            override = x:
              (pluggable (terraform.override x)).withPlugins plugins;
          };
          # Don't bother wrapping unless we actually have plugins, since the wrapper will stop automatic downloading
          # of plugins, which might be counterintuitive if someone just wants a vanilla Terraform.
        in
        if actualPlugins == [ ] then
          terraform.overrideAttrs
            (orig: { passthru = orig.passthru // passthru; })
        else
          lib.appendToName "with-plugins" (buildEnv {
            inherit (terraform) name meta;
            paths = actualPlugins;
            nativeBuildInputs = [ makeWrapper ];
            postBuild = ''
              mkdir -p $out/bin
              makeWrapper "${terraform}/bin/terraform" "$out/bin/terraform" \
                --set NIX_TERRAFORM_PLUGIN_DIR $out/libexec/terraform-providers \
                --prefix PATH : "${lib.makeBinPath wrapperInputs}"
            '';
          });
    in
    withPlugins (_: [ ]);

  plugins = removeAttrs terraform-providers [
    "override"
    "overrideDerivation"
    "recurseForDerivations"
  ];
in
rec {
  # Constructor for other terraform versions
  mkTerraform = attrs: pluggable (generic attrs);

  terraform_0_13 = mkTerraform {
    version = "0.13.7";
    sha256 = "1cahnmp66dk21g7ga6454yfhaqrxff7hpwpdgc87cswyq823fgjn";
    patches = [ ./provider-path.patch ];
    passthru = { inherit plugins; };
  };

  terraform_0_14 = mkTerraform {
    version = "0.14.11";
    sha256 = "1yi1jj3n61g1kn8klw6l78shd23q79llb7qqwigqrx3ki2mp279j";
    vendorSha256 = "sha256-tWrSr6JCS9s+I0T1o3jgZ395u8IBmh73XGrnJidWI7U=";
    patches = [ ./provider-path.patch ];
    passthru = { inherit plugins; };
  };

  terraform_0_15 = mkTerraform {
    version = "0.15.5";
    sha256 = "18f4a6l24s3cym7gk40agxikd90i56q84wziskw1spy9rgv2yx6d";
    vendorSha256 = "sha256-oFvoEsDunJR4IULdGwS6nHBKWEgUehgT+nNM41W/GYo=";
    patches = [ ./provider-path-0_15.patch ];
    passthru = { inherit plugins; };
  };

  terraform_1 = mkTerraform {
    version = "1.1.4";
    sha256 = "sha256-PzBdo4zqWB9ma+uYFGmZtJNCXlRnAHxQmzWxZFPzHH0=";
    vendorSha256 = "sha256-Rk2hHtJfaS553MJIea6n51irMas3qcBrWAD+adzTi1Y=";
    patches = [ ./provider-path-0_15.patch ];
    passthru = { inherit plugins; };
  };

  # Tests that the plugins are being used. Terraform looks at the specific
  # file pattern and if the plugin is not found it will try to download it
  # from the Internet. With sandboxing enable this test will fail if that is
  # the case.
  terraform_plugins_test =
    let
      mainTf = writeText "main.tf" ''
        resource "random_id" "test" {}
      '';
      terraform = terraform_1.withPlugins (p: [ p.random ]);
      test =
        runCommand "terraform-plugin-test" { buildInputs = [ terraform ]; } ''
          set -e
          # make it fail outside of sandbox
          export HTTP_PROXY=http://127.0.0.1:0 HTTPS_PROXY=https://127.0.0.1:0
          cp ${mainTf} main.tf
          terraform init
          touch $out
        '';
    in
    test;

}
