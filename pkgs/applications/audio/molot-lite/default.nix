{ lib, stdenv, fetchFromGitHub, lv2 }:

stdenv.mkDerivation rec {

  pname = "molot-lite";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "magnetophon";
    repo = pname;
    rev = version;
    sha256 = "0xbvicfk1rgp01nlg6hlym9bnygry0nrbv88mv7w6hnacvl63ba4";
  };

  buildInputs = [ lv2 ];

  makeFlags = [ "INSTALL_DIR=$out/lib/lv2" ];

  installPhase = ''
    runHook preInstall
    make install INSTALL_DIR=$out/lib/lv2 -C Molot_Mono_Lite
    make install INSTALL_DIR=$out/lib/lv2 -C Molot_Stereo_Lite
    runHook postInstall
  '';

  meta = with lib; {
    description = "Stereo and mono audio signal dynamic range compressor in LV2 format";
    homepage = "https://github.com/magnetophon/molot-lite";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
  };
}
