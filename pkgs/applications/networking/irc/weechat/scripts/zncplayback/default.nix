{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation {
  pname = "weechat-zncplayback";
  version = "0.2.1";

  src = fetchurl {
    url = "https://github.com/weechat/scripts/raw/bcc9643136addd2cd68ac957dd64e336e4f88aa1/python/zncplayback.py";
    hash = "sha256-w5/PK4gncVm5ymOPrxI96vdg6v6I3EiMeYC8rqy5Ysw=";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/share
    cp $src $out/share/zncplayback.py
  '';

  passthru = {
    scripts = [ "zncplayback.py" ];
  };

  meta = {
    description = "Add support for the ZNC Playback module";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ qyliss ];
  };
}
