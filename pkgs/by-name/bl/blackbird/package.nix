{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  gtk-engine-murrine,
}:

stdenv.mkDerivation rec {
  pname = "Blackbird";
  version = "2017-12-13";

  src = fetchFromGitHub {
    repo = pname;
    owner = "shimmerproject";
    rev = "a1c5674c0ec38b4cc8ba41d2c0e6187987ae7eb4";
    sha256 = "0xskcw36ci2ykra5gir5pkrawh2qkcv18p4fp2kxivssbd20d4jw";
  };

  nativeBuildInputs = [ autoreconfHook ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  meta = {
    description = "Dark Desktop Suite for Gtk, Xfce and Metacity";
    homepage = "https://github.com/shimmerproject/Blackbird";
    license = with lib.licenses; [
      gpl2Plus
      cc-by-nc-sa-30
    ];
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.romildo ];
  };
}
