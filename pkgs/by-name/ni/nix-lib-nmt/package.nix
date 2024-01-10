{ lib, stdenv, fetchurl }:

let version = "0.5.0";
in stdenv.mkDerivation {
  pname = "nix-lib-nmt";
  inherit version;

  # TODO: Restore when Sourcehut once its back from DDoS attack.
  # src = fetchFromSourcehut {
  #   owner = "~rycee";
  #   repo = "nmt";
  #   rev = "v${version}";
  #   hash = "sha256-1glxIg/b+8qr+ZsSsBqZIqGpsYWzRuMyz74/sy765Uk=";
  # };

  src = fetchurl {
    url = "https://rycee.net/tarballs/nmt-${version}.tar.gz";
    hash = "sha256-AO1iLsfZSLbR65tRBsAqJ98CewfSl5yNf7C6XaZj0wM=";
  };

  installPhase = ''
    mkdir -pv "$out"
    cp -rv * "$out"
  '';

  meta = {
    homepage = "https://git.sr.ht/~rycee/nmt";
    description = "A basic test framework for projects using the Nixpkgs module system";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rycee ];
  };
}
