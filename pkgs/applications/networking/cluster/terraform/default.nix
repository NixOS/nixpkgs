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

  terraform_0_9_4 = generic {
    version   = "0.9.4";
    sha256    = "07vcmjyl0y48hm5lqqzdd51hmrxapvywzbdkg5f3rcqd7dn9c2xs";
    postPatch = ''
      rm builtin/providers/dns/data_dns_cname_record_set_test.go
      rm builtin/providers/vsphere/resource_vsphere_file_test.go
    '';
    doCheck   = true;
  };

  terraform_0_9_6 = generic {
    version = "0.9.6";
    sha256 = "1f6z1zkklzpqgc7akgdz1g306ccmhni5lmg7i6g762n3qai60bnv";
    doCheck = true;
  };

  terraform_0_9_9 = generic {
    version = "0.9.9";
    sha256 = "1pa9dd87dcjnn7fm1qn63da5qx87l7xjqlwiczrswcjfbismvl1p";
    doCheck = true;
  };
}
