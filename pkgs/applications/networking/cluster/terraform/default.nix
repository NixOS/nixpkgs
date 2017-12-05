{ stdenv, lib, buildGoPackage, fetchpatch, fetchFromGitHub }:

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

  terraform_0_9_11 = generic {
    version = "0.9.11";
    sha256 = "045zcpd4g9c52ynhgh3213p422ahds63mzhmd2iwcmj88g8i1w6x";
    # checks are failing again
    doCheck = false;
  };

  terraform_0_10_0 = generic {
    version = "0.10.0";
    sha256 = "1z6pmyfh4z5w8k2j46ancc0m9lsiq6d0m56nxj1kawb3n5q9dgds";
    # remove debugging and the -dev postfix in the version
    preBuild = ''
      buildFlagsArray=(
        -ldflags
        "-X github.com/hashicorp/terraform/terraform.VersionPrerelease= -s -w"
      )
    '';
  };
}
