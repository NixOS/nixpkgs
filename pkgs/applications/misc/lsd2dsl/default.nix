{ mkDerivation, lib, fetchFromGitHub, cmake
, boost, libvorbis, libsndfile, minizip, gtest }:

mkDerivation rec {
  pname = "lsd2dsl";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "nongeneric";
    repo = pname;
    rev = "v${version}";
    sha256 = "15xjp5xxvl0qc4zp553n7djrbvdp63sfjw406idgxqinfmkqkqdr";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ boost libvorbis libsndfile minizip gtest ];

  NIX_CFLAGS_COMPILE = "-Wno-error=unused-result";

  installPhase = ''
    install -Dm755 lsd2dsl $out/bin/lsd2dsl
    install -m755 qtgui/lsd2dsl-qtgui $out/bin/lsd2dsl-qtgui
  '';

  meta = with lib; {
    homepage = "https://rcebits.com/lsd2dsl/";
    description = "Lingvo dictionaries decompiler";
    longDescription = ''
      A decompiler for ABBYY Lingvo’s proprietary dictionaries.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ sikmir ];
    platforms = with platforms; linux;
  };
}
