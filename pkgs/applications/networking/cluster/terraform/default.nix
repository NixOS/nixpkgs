{ stdenv
, lib
, buildEnv
, buildGoPackage
, fetchFromGitHub
, makeWrapper
, runCommand
, writeText
, terraform-providers
}:

let
  goPackagePath = "github.com/hashicorp/terraform";

  generic = { version, sha256, ... }@attrs:
    let attrs' = builtins.removeAttrs attrs ["version" "sha256"]; in
    buildGoPackage ({
      name = "terraform-${version}";

      inherit goPackagePath;

      src = fetchFromGitHub {
        owner  = "hashicorp";
        repo   = "terraform";
        rev    = "v${version}";
        inherit sha256;
      };

      postInstall = ''
        # remove all plugins, they are part of the main binary now
        for i in $bin/bin/*; do
          if [[ $(basename $i) != terraform ]]; then
            rm "$i"
          fi
        done
      '';

      preCheck = ''
        export HOME=$TMP
      '';

      meta = with stdenv.lib; {
        description = "Tool for building, changing, and versioning infrastructure";
        homepage = https://www.terraform.io/;
        license = licenses.mpl20;
        maintainers = with maintainers; [ zimbatm peterhoeg kalbasit ];
      };
    } // attrs');

  pluggable = terraform:
    let
      withPlugins = plugins:
        let
          actualPlugins = plugins terraform.plugins;

          # Wrap PATH of plugins propagatedBuildInputs, plugins may have runtime dependencies on external binaries
          wrapperInputs = lib.unique (lib.flatten (lib.catAttrs "propagatedBuildInputs" (builtins.filter (x: x != null) actualPlugins)));

          passthru = {
            withPlugins = newplugins: withPlugins (x: newplugins x ++ actualPlugins);
            full = withPlugins lib.attrValues;

            # Ouch
            overrideDerivation = f: (pluggable (terraform.overrideDerivation f)).withPlugins plugins;
            overrideAttrs = f: (pluggable (terraform.overrideAttrs f)).withPlugins plugins;
            override = x: (pluggable (terraform.override x)).withPlugins plugins;
          };
        in
          # Don't bother wrapping unless we actually have plugins, since the wrapper will stop automatic downloading
          # of plugins, which might be counterintuitive if someone just wants a vanilla Terraform.
          if actualPlugins == []
            then terraform.overrideAttrs (orig: { passthru = orig.passthru // passthru; })
            else lib.appendToName "with-plugins"(stdenv.mkDerivation {
              inherit (terraform) name;
              buildInputs = [ makeWrapper ];

              buildCommand = ''
                mkdir -p $out/bin/
                makeWrapper "${terraform.bin}/bin/terraform" "$out/bin/terraform" \
                  --set NIX_TERRAFORM_PLUGIN_DIR "${buildEnv { name = "tf-plugin-env"; paths = actualPlugins; }}/bin" \
                  --prefix PATH : "${lib.makeBinPath wrapperInputs}"
              '';

              inherit passthru;
            });
    in withPlugins (_: []);

  plugins = removeAttrs terraform-providers ["override" "overrideDerivation" "recurseForDerivations"];
in rec {
  terraform_0_11 = pluggable (generic {
    version = "0.11.13";
    sha256 = "014d2ibmbp5yc1802ckdcpwqbm5v70xmjdyh5nadn02dfynaylna";
    patches = [ ./provider-path.patch ];
    passthru = { inherit plugins; };
  });

  terraform_0_11-full = terraform_0_11.full;

  terraform_0_12 = pluggable (generic {
    version = "0.12.0-rc1";
    sha256 = "1ap1q5bixkzshnwy8xyfh768qwg3y4pcjzaiajzn2icjf4ay5nqm";
    patches = [ ./provider-path.patch ];
    passthru = { inherit plugins; };
  });

  # Tests that the plugins are being used. Terraform looks at the specific
  # file pattern and if the plugin is not found it will try to download it
  # from the Internet. With sandboxing enable this test will fail if that is
  # the case.
  terraform_plugins_test = let
    mainTf = writeText "main.tf" ''
      resource "random_id" "test" {}
    '';
    terraform = terraform_0_11.withPlugins (p: [ p.random ]);
    test = runCommand "terraform-plugin-test" { buildInputs = [terraform]; }
      ''
        set -e
        # make it fail outside of sandbox
        export HTTP_PROXY=http://127.0.0.1:0 HTTPS_PROXY=https://127.0.0.1:0
        cp ${mainTf} main.tf
        terraform init
        touch $out
      '';
  in test;

}
