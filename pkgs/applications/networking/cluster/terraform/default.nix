{ stdenv, lib, buildGoPackage, fetchurl, fetchFromGitHub }:

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

in {
  terraform_0_8_5 = generic {
    version = "0.8.5";
    sha256 = "1cxwv3652fpsbm2zk1akw356cd7w7vhny1623ighgbz9ha8gvg09";
  };

  terraform_0_8_8 = generic {
    version = "0.8.8";
    sha256 = "0ibgpcpvz0bmn3cw60nzsabsrxrbmmym1hv7fx6zmjxiwd68w5gb";
  };

  terraform_0_9_2 = generic {
    version = "0.9.2";
    sha256 = "1yj5x1d10028fm3v3gjyjdn128ps0as345hr50y8x3vn86n70lxl";

    patches = [
      (fetchurl {
        url = "https://github.com/hashicorp/terraform/pull/13237.patch";
        sha256 = "1f7hr1l5hck9mmqk01p6wxbfv9r3b0yi9ypz7bcmikp3bikza98x";
      })
      (fetchurl {
        url = "https://github.com/hashicorp/terraform/pull/13248.patch";
        sha256 = "1qc57kjhlqg5339him9bg4izdphins2fjjhb4ffr7bv9lb5k0hkr";
      })
    ];

    doCheck = true;
  };
}
