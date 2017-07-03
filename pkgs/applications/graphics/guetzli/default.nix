{ stdenv, libpng, fetchFromGitHub, pkgconfig }:
let
  version = "1.0.1";
in
stdenv.mkDerivation {
  name = "guetzli-${version}";
  src = fetchFromGitHub {
    owner = "google";
    repo = "guetzli";
    rev = "v${version}";
    sha256 = "1wy9wfvyradp0aigfv8yijvj0dgb5kpq2yf2xki15f605jc1r5dm";
  };
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libpng ];

  installPhase = ''
    mkdir -p $out/bin
    install bin/Release/guetzli $out/bin/
  '';

  meta = {
    description = "Perceptual JPEG encoder";
    longDescription = "Guetzli is a JPEG encoder that aims for excellent compression density at high visual quality.";
    homepage = "https://github.com/google/guetzli";
    license = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.x86_64;
    maintainers = [ stdenv.lib.maintainers.seppeljordan ];
  };
}
