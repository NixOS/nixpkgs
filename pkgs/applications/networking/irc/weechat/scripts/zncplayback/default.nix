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
    sha256 = "1k32p6naxg40g664ip48zvm61xza7l9az3v3rawmjw97i0mwz7y3";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/share
    cp $src $out/share/zncplayback.py
  '';

  passthru = {
    scripts = [ "zncplayback.py" ];
  };

  meta = with lib; {
    description = "Add support for the ZNC Playback module";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ qyliss ];
  };
}
