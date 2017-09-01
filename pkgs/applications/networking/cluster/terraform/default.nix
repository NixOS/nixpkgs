{ stdenv, lib, buildEnv, buildGoPackage, fetchpatch, fetchFromGitHub, makeWrapper }:

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
        maintainers = with maintainers; [ jgeerds zimbatm peterhoeg ];
      };
    } // attrs');

  pluggable = terraform:
    let
      withPlugins = plugins:
        let
          actualPlugins = plugins terraform.plugins;

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
            else stdenv.mkDerivation {
              name = "${terraform.name}-with-plugins";
              buildInputs = [ makeWrapper ];

              buildCommand = ''
                mkdir -p $out/bin/
                makeWrapper "${terraform.bin}/bin/terraform" "$out/bin/terraform" \
                  --set NIX_TERRAFORM_PLUGIN_DIR "${buildEnv { name = "tf-plugin-env"; paths = actualPlugins; }}/bin"
              '';

              inherit passthru;
            };
    in withPlugins (_: []);

  plugins = import ./providers { inherit stdenv lib buildGoPackage fetchFromGitHub; };
in {
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
    version = "0.10.2";
    sha256 = "1q7za7jcfqv914a3ynfl7hrqbgwcahgm418kivjrac6p1q26w502";
    patches = [ ./provider-path.patch ];
    passthru = { inherit plugins; };
  });
}
