{ stdenv, mkDerivation, lib, fetchFromGitHub, cmake
, boost, libvorbis, libsndfile, minizip, gtest, qtwebkit }:

mkDerivation rec {
  pname = "lsd2dsl";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "nongeneric";
    repo = pname;
    rev = "v${version}";
    sha256 = "0s0la6zkg584is93p4nj1ha3pbnvadq84zgsv8nym3r35n7k8czi";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ boost libvorbis libsndfile minizip gtest qtwebkit ];

  NIX_CFLAGS_COMPILE = "-Wno-error=unused-result -Wno-error=missing-braces";

  installPhase = ''
    install -Dm755 console/lsd2dsl gui/lsd2dsl-qtgui -t $out/bin
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
