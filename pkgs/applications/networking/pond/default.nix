{ stdenv, lib, fetchgit, fetchhg, go, trousers }:

let deps = import ./deps.nix {
  inherit stdenv lib fetchgit fetchhg;
};

in stdenv.mkDerivation rec {
  name = "pond";

  buildInputs  = [ go trousers ];

  unpackPhase = ''
    export GOPATH=$PWD
    echo $PWD
    cp -LR ${deps}/src src
    chmod u+w -R src
  '';

  installPhase = ''
    export GOPATH="$PWD"
    mkdir -p $out/bin
    go build --tags nogui -v -o $out/bin/pond-cli github.com/agl/pond/client
  '';

  meta = with lib; {
    description = "Forward secure, asynchronous messaging for the discerning";
    homepage = https://pond.imperialviolet.org;
    license = licenses.bsd3;
    platforms = platforms.linux;
  };
}

