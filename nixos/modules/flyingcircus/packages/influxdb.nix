# InfluxDB 0.11 pre-prelease.
# We need this version (or newer) since older versions don't support the
# "fields*" operator in graphite pattern matching.
{ lib, goPackages, fetchFromGitHub, fetchgit, ... }:

goPackages.buildGoPackage rec {
  name = "influxdb-${rev}";
  rev = "16eea8eecc81513d935d92a12bb3c26f21cf339f";
  goPackagePath = "github.com/influxdata/influxdb";

  src = fetchFromGitHub {
    inherit rev;
    owner = "influxdata";
    repo = "influxdb";
    sha256 = "17dc8agkjb5mancvc0hvlw588a8v81sdgwpm8csj2awfa03w3ylh";
  };

  excludedPackages = "test";

  propagatedBuildInputs = [

    (goPackages.buildGoPackage rec {
        name = "crypto-${rev}";
        goPackagePath = "golang.org/x/crypto";
        rev = "1f22c0103821b9390939b6776727195525381532";

        src = fetchgit {
            inherit rev;
            url = "git://github.com/golang/crypto";
            sha256 = "30c494d5ce80c793de4d2da97f43a7631bf1c4eece67644f3a47b2f492dd5015";
        };
    })


    (goPackages.buildGoPackage rec {
        name = "pool.v2-${rev}";
        goPackagePath = "gopkg.in/fatih/pool.v2";
        rev = "cba550ebf9bce999a02e963296d4bc7a486cb715";

        src = fetchgit {
            inherit rev;
            url = "git://github.com/fatih/pool";
            sha256 = "a627e4a03d15816bdb6a55de2976e135b03dfbb9f192596b414002e832e91a7a";
        };
    })


    (goPackages.buildGoPackage rec {
        name = "go-collectd-${rev}";
        goPackagePath = "collectd.org/";
        rev = "9fc824c70f713ea0f058a07b49a4c563ef2a3b98";

        src = fetchgit {
            inherit rev;
            url = "git://github.com/collectd/go-collectd";
            sha256 = "8ea42cb13a8ae1bf5a66af5cf326d6c55a5de787f2bdb2d6df73bbe49bb0e85f";
        };
    })


    goPackages.statik

    (goPackages.buildGoPackage rec {
        name = "toml-${rev}";
        goPackagePath = "github.com/BurntSushi/toml";
        rev = "5c4df71dfe9ac89ef6287afc05e4c1b16ae65a1e";

        src = fetchgit {
            inherit rev;
            url = "git://github.com/BurntSushi/toml";
            sha256 = "031a62be9afd66764cbe245337c9b52e08b578f46770a7638bf8df71ab82dbe7";
        };
    })

    goPackages.armon.go-metrics

    (goPackages.buildGoPackage rec {
        name = "pat-${rev}";
        goPackagePath = "github.com/bmizerany/pat";
        rev = "b8a35001b773c267eb260a691f4e5499a3531600";

        src = fetchgit {
            inherit rev;
            url = "git://github.com/bmizerany/pat";
            sha256 = "8149a26def50b0ad3f2f374395dad4f447b98a777933e5db1f9c7dd5188fb91c";
        };
    })

    (goPackages.buildGoPackage rec {
        name = "go-spew-${rev}";
        goPackagePath = "github.com/davecgh/go-spew";
        rev = "fc32781af5e85e548d3f1abaf0fa3dbe8a72495c";

        src = fetchgit {
            inherit rev;
            url = "git://github.com/davecgh/go-spew";
            sha256 = "6c51587ef356f01e3c907c5c8b4a7be4402ca7b4e66b7c5b94a88f728e4f5957";
        };
    })


    (goPackages.buildGoPackage rec {
        name = "go-bits-${rev}";
        goPackagePath = "github.com/dgryski/go-bits";
        rev = "86c69b3c986f9d40065df5bd8f765796549eef2e";

        src = fetchgit {
            inherit rev;
            url = "git://github.com/dgryski/go-bits";
            sha256 = "0b9dbbbcae492d45e272ef6ad97c815dcfb7106b18c5cdeb4328ebc828ba2322";
        };
    })


    (goPackages.buildGoPackage rec {
        name = "go-bitstream-${rev}";
        goPackagePath = "github.com/dgryski/go-bitstream";
        rev = "27cd5973303fde7d914860be1ea4b927a6be0c92";

        src = fetchgit {
            inherit rev;
            url = "git://github.com/dgryski/go-bitstream";
            sha256 = "86cdf6271a6c1ee26398faf20dde0c8ccce002079f0d82bd089f01efd826518a";
        };
    })


    (goPackages.buildGoPackage rec {
        name = "protobuf-${rev}";
        goPackagePath = "github.com/gogo/protobuf";
        rev = "82d16f734d6d871204a3feb1a73cb220cc92574c";

        src = fetchgit {
            inherit rev;
            url = "git://github.com/gogo/protobuf";
            sha256 = "fc1227011f1aa5055e4a5c3a47c1fcbef9a89393ac27a148283f5de1e44ad288";
        };
    })


    (goPackages.buildGoPackage rec {
        name = "snappy-${rev}";
        goPackagePath = "github.com/golang/snappy";
        rev = "5979233c5d6225d4a8e438cdd0b411888449ddab";

        src = fetchgit {
            inherit rev;
            url = "git://github.com/golang/snappy";
            sha256 = "261e34baa64e56ffa7068e086e253f83259800f2dd6e539b69fb0afa6279b989";
        };
    })


    (goPackages.buildGoPackage rec {
        name = "go-msgpack-${rev}";
        goPackagePath = "github.com/hashicorp/go-msgpack";
        rev = "fa3f63826f7c23912c15263591e65d54d080b458";

        src = fetchgit {
            inherit rev;
            url = "git://github.com/hashicorp/go-msgpack";
            sha256 = "3394e47b7bb2dda2cf537aef66e67d414f5b60cf98a16ec8cca236519769d9b8";
        };
    })


    goPackages.raft
    goPackages.raft-boltdb

    (goPackages.buildGoPackage rec {
        name = "usage-client-${rev}";
        goPackagePath = "github.com/influxdata/usage-client";
        rev = "475977e68d79883d9c8d67131c84e4241523f452";

        # goPackageAliases = [ "github.com/influxdata/usage-client/v1"
        #                     "github.com/influxdb/usage-client/v1" ];

        src = fetchgit {
            inherit rev;
            url = "git://github.com/influxdata/usage-client";
            sha256 = "14d73c989afadc760f14201da2ecfc6d7f921c8c3af8743c0f3b09648dc9e5e2";
        };
    })


    (goPackages.buildGoPackage rec {
        name = "encoding-${rev}";
        goPackagePath = "github.com/jwilder/encoding";
        rev = "07d88d4f35eec497617bee0c7bfe651a796dae13";

        src = fetchgit {
            inherit rev;
            url = "git://github.com/jwilder/encoding";
            sha256 = "7a763faf439f9334e42b957105914652a66c2509474b5090de7238c24feef02c";
        };
    })


    (goPackages.buildGoPackage rec {
        name = "gollectd-${rev}";
        goPackagePath = "github.com/kimor79/gollectd";
        rev = "61d0deeb4ffcc167b2a1baa8efd72365692811bc";

        src = fetchgit {
            inherit rev;
            url = "git://github.com/kimor79/gollectd";
            sha256 = "3b8345ea49240837dab7e60c7000703e8ae77999e2ed7fc653ef452d7d9660a7";
        };
    })


    (goPackages.buildGoPackage rec {
        name = "ratecounter-${rev}";
        goPackagePath = "github.com/paulbellamy/ratecounter";
        rev = "5a11f585a31379765c190c033b6ad39956584447";

        src = fetchgit {
            inherit rev;
            url = "git://github.com/paulbellamy/ratecounter";
            sha256 = "affd743e5ee00d381341779b251214dc5d7f8a83121921c92673f2e09ea46714";
        };
    })


    (goPackages.buildGoPackage rec {
        name = "liner-${rev}";
        goPackagePath = "github.com/peterh/liner";
        rev = "ad1edfd30321d8f006ccf05f1e0524adeb943060";

        src = fetchgit {
            inherit rev;
            url = "git://github.com/peterh/liner";
            sha256 = "278cef2eac22a60e23cab094c0713ae38c36ae8e82062850ca07db17646a4430";
        };
    })


  ];
  meta = with lib; {
    description = "An open-source distributed time series database";
    license = licenses.mit;
    homepage = https://influxdb.com/;
    maintainers = with maintainers; [ offline ];
    platforms = platforms.linux;
  };
}
