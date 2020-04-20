{ stdenv, mkDerivation, lib, fetchFromGitHub, cmake
, boost, libvorbis, libsndfile, minizip, gtest, qtwebkit }:

mkDerivation rec {
  pname = "lsd2dsl";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "nongeneric";
    repo = pname;
    rev = "v${version}";
    sha256 = "100qd9i0x6r0nkw1ic2p0xjr16jlhinxkn1x7i98s4xmw4wyb8n8";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ boost libvorbis libsndfile minizip gtest qtwebkit ];

  NIX_CFLAGS_COMPILE = "-Wno-error=unused-result -Wno-error=missing-braces";

  installPhase = ''
    install -Dm755 console/lsd2dsl $out/bin/lsd2dsl
    install -m755 gui/lsd2dsl-qtgui $out/bin/lsd2dsl-qtgui
  '' + lib.optionalString stdenv.isDarwin ''
    wrapQtApp $out/bin/lsd2dsl
    wrapQtApp $out/bin/lsd2dsl-qtgui
  '';

  meta = with lib; {
    homepage = "https://rcebits.com/lsd2dsl/";
    description = "Lingvo dictionaries decompiler";
    longDescription = ''
      A decompiler for ABBYY Lingvo’s proprietary dictionaries.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ sikmir ];
    platforms = with platforms; linux ++ darwin;
  };
}
