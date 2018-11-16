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
        maintainers = with maintainers; [ jgeerds zimbatm peterhoeg kalbasit ];
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
  terraform_0_8_5 = generic {
    version = "0.8.5";
    sha256 = "1cxwv3652fpsbm2zk1akw356cd7w7vhny1623ighgbz9ha8gvg09";
  };

  terraform_0_8 = generic {
    version = "0.8.8";
    sha256 = "0ibgpcpvz0bmn3cw60nzsabsrxrbmmym1hv7fx6zmjxiwd68w5gb";
  };

  terraform_0_9 = generic {
    version = "0.9.11";
    sha256 = "045zcpd4g9c52ynhgh3213p422ahds63mzhmd2iwcmj88g8i1w6x";
    # checks are failing again
    doCheck = false;
  };

  terraform_0_10 = pluggable (generic {
    version = "0.10.8";
    sha256 = "11hhij0hq99xhwlg5dx5nv7y074x79wkr8hr3wc6ln0kwdk5scdf";
    patches = [ ./provider-path.patch ];
    passthru = { inherit plugins; };
  });

  terraform_0_10-full = terraform_0_10.withPlugins lib.attrValues;

  terraform_0_11 = pluggable (generic {
    version = "0.11.10";
    sha256 = "08mapla89g106bvqr41zfd7l4ki55by6207qlxq9caiha54nx4nb";
    patches = [ ./provider-path.patch ];
    passthru = { inherit plugins; };
  });

  terraform_0_11-full = terraform_0_11.withPlugins lib.attrValues;

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
