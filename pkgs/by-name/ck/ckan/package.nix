{ lib, stdenv, fetchurl, makeWrapper, mono, gtk2, curl }:

stdenv.mkDerivation rec {
  pname = "ckan";
  version = "1.35.2";

  src = fetchurl {
    url = "https://github.com/KSP-CKAN/CKAN/releases/download/v${version}/ckan.exe";
    sha256 = "sha256-SK2eKdH/bm+W+qU8XUHRD9uffmfp5bR4dBvBEUKCm8E=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ mono ];

  libraries = lib.makeLibraryPath [ gtk2 curl ];

  dontBuild = true;

  installPhase = ''
    install -m 644 -D $src $out/bin/ckan.exe
    makeWrapper ${mono}/bin/mono $out/bin/ckan \
      --add-flags $out/bin/ckan.exe \
      --set LD_LIBRARY_PATH $libraries
  '';

  meta = with lib; {
    description = "Mod manager for Kerbal Space Program";
    mainProgram = "ckan";
    homepage = "https://github.com/KSP-CKAN/CKAN";
    license = licenses.mit;
    maintainers = with maintainers; [ Baughn ymarkus ];
    platforms = platforms.all;
  };
}
