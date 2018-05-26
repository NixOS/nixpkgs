{ stdenv, buildGoPackage, fetchFromGitHub, fetchgit, clang }:

buildGoPackage rec {
  name = "ethsign-${version}";
  version = "0.8.2";

  goPackagePath = "github.com/dapphub/ethsign";
  hardeningDisable = ["fortify"];

  src = fetchFromGitHub {
    owner = "dapphub";
    repo = "ethsign";
    rev = "v${version}";
    sha256 = "1gd0bq5x49sjm83r2wivjf03dxvhdli6cvwb9b853wwcvy4inmmh";
  };

  extraSrcs = [
    {
      goPackagePath = "github.com/ethereum/go-ethereum";
      src = fetchFromGitHub {
        owner = "ethereum";
        repo = "go-ethereum";
        rev = "v1.7.3";
        sha256 = "1w6rbq2qpjyf2v9mr18yiv2af1h2sgyvgrdk4bd8ixgl3qcd5b11";
      };
    }
    {
      goPackagePath = "gopkg.in/urfave/cli.v1";
      src = fetchFromGitHub {
        owner = "urfave";
        repo = "cli";
        rev = "v1.19.1";
        sha256 = "1ny63c7bfwfrsp7vfkvb4i0xhq4v7yxqnwxa52y4xlfxs4r6v6fg";
      };
    }
    {
      goPackagePath = "golang.org/x/crypto";
      src = fetchgit {
        url = "https://go.googlesource.com/crypto";
        rev = "94eea52f7b742c7cbe0b03b22f0c4c8631ece122";
        sha256 = "095zyvjb0m2pz382500miqadhk7w3nis8z3j941z8cq4rdafijvi";
      };
    }
    {
      goPackagePath = "golang.org/x/sys";
      src = fetchgit {
        url = "https://go.googlesource.com/sys";
        rev = "53aa286056ef226755cd898109dbcdaba8ac0b81";
        sha256 = "1yd17ccklby099cpdcsgx6lf0lj968hsnppp16mwh9009ldf72r1";
      };
    }
  ];

  meta = with stdenv.lib; {
    homepage = https://github.com/dapphub/ethsign;
    description = "Make raw signed Ethereum transactions";
    license = [licenses.gpl3];
  };
}
