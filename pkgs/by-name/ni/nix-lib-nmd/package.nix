{ lib, stdenv, fetchurl }:

let version = "0.5.0";
in stdenv.mkDerivation {
  pname = "nix-lib-nmd";
  inherit version;

  # TODO: Restore when Sourcehut once its back from DDoS attack.
  # src = fetchFromSourcehut {
  #   owner = "~rycee";
  #   repo = "nmd";
  #   rev = "v${version}";
  #   hash = "sha256-1glxIg/b+8qr+ZsSsBqZIqGpsYWzRuMyz74/sy765Uk=";
  # };

  src = fetchurl {
    url = "https://rycee.net/tarballs/nmd-${version}.tar.gz";
    hash = "sha256-+65+VYFgnbFGzCyyQytyxVStSZwEP989qi/6EDOdA8A=";
  };

  installPhase = ''
    mkdir -v "$out"
    cp -rv * "$out"
  '';

  meta = {
    homepage = "https://git.sr.ht/~rycee/nmd";
    description = "A documentation framework for projects based on NixOS modules";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rycee ];
  };
}
