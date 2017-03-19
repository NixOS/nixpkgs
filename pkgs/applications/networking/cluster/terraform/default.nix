{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

let
  generic = { version, sha256 }:
  buildGoPackage rec {
    name = "terraform-${version}";

    goPackagePath = "github.com/hashicorp/terraform";

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

    doCheck = true;

    meta = with stdenv.lib; {
      description = "Tool for building, changing, and versioning infrastructure";
      homepage = https://www.terraform.io/;
      license = licenses.mpl20;
      maintainers = with maintainers; [ jgeerds zimbatm peterhoeg ];
    };
  };

in rec {
  terraform_0_8_5 = generic {
    version = "0.8.5";
    sha256 = "1cxwv3652fpsbm2zk1akw356cd7w7vhny1623ighgbz9ha8gvg09";
  };

  terraform_0_8_8 = generic {
    version = "0.8.8";
    sha256 = "0ibgpcpvz0bmn3cw60nzsabsrxrbmmym1hv7fx6zmjxiwd68w5gb";
  };

  terraform_0_9_0 = generic {
    version = "0.9.0";
    sha256 = "1v96qgc6pd1bkwvkz855625xdcy7xb5lk60lg70144idqmwfjb9g";
  };

  terraform_0_8 = terraform_0_8_8;
  terraform_0_9 = terraform_0_9_0;
  terraform = terraform_0_9;
}
