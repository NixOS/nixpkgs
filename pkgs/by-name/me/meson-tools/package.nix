{
  lib,
  stdenv,
  fetchFromGitHub,
  openssl,
}:

stdenv.mkDerivation rec {
  pname = "meson-tools";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "afaerber";
    repo = pname;
    rev = "v${version}";
    sha256 = "1bvshfa9pa012yzdwapi3nalpgcwmfq7d3n3w3mlr357a6kq64qk";
  };

  buildInputs = [ openssl ];

  installPhase = ''
    mkdir -p "$out/bin"
    mv amlbootsig unamlbootsig amlinfo "$out/bin"
  '';

  meta = with lib; {
    homepage = "https://github.com/afaerber/meson-tools";
    description = "Tools for Amlogic Meson ARM platforms";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ lopsided98 ];
  };
}
