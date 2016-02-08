{ lib, goPackages, fetchFromGitHub, stdenv, callPackage, strace, git }:

let

  version = "0.13.0";

  uchiwa_src = fetchFromGitHub {
    owner = "sensu";
    repo = "uchiwa";
    rev = "${version}";
    sha256 = "05v7d29fjcxm55xajlmnph6yjlj8bx0hnnmgjagp36blk7jxyml0";
  };


  uchiwa_go_package = goPackages.buildGoPackage rec {
    inherit version;

    name = "uchiwa-${version}";
    goPackagePath = "github.com/sensu/uchiwa";

    buildInputs = [
        goPackages.context
        goPackages.mapstructure

          (goPackages.buildGoPackage rec {
            name = "dgrijalva-jwt-go-${rev}";
            goPackagePath = "github.com/dgrijalva/jwt-go";
            rev = "v2.2.0-15-g61124b6";

            src = fetchFromGitHub {
              inherit rev;
              owner = "dgrijalva";
              repo = "jwt-go";
              sha256 = "1pjianfr96rxa5b9sc9659gnay3kqwhcmjw26z77gznfjxajigqd";
            };
          })

#          (goPackages.buildGoPackage rec {
#            name = "palourde-mergo-${rev}";
#            goPackagePath = "github.com/palourde/mergo";
#            rev = "v0.2.0-10-gd931ffd";
#
#            src = fetchFromGitHub {
#              inherit rev;
#              owner = "palourde";
#              repo = "mergo";
#              sha256 = "0kdwx97fqxhk3ia3bf6z0q3ayb7mmdh7d7i8rihzlyxi28wpj072";
#            };
#          })

    ];

    src = uchiwa_src;
  };

  nodePackages = callPackage <nixpkgs/pkgs/top-level/node-packages.nix> {
    self = nodePackages;
    generated = ./packages.nix;
  };

in

  stdenv.mkDerivation rec {

    name="uchiwa-${version}";

    src = uchiwa_src;

    buildInputs = [ uchiwa_go_package nodePackages.bower strace git ];

    buildPhase = ''
       echo "asdf"
       export HOME=$(pwd)
       bower --allow-root install
       find public
 '';

    installPhase = ''
      mkdir -p $out/bin
      ln -s ${uchiwa_go_package.bin}/bin/uchiwa $out/bin/uchiwa
      ln -s ${uchiwa_go_package}/share $out/share
      cp -a public $out/
'';

    meta = with lib; {
      description = "Uchiwa is a simple dashboard for the Sensu monitoring framework.";
      homepage    = http://uchiwa.io/;
      license     = licenses.mit;
      maintainers = with maintainers; [ theuni ];
      platforms   = platforms.unix;
    };

}
