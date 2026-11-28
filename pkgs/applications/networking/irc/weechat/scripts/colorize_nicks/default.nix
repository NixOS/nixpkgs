{
  stdenv,
  lib,
  fetchurl,
  weechat,
}:

stdenv.mkDerivation {
  pname = "weechat-colorize_nicks";
  version = "35";

  src = fetchurl {
    url = "https://github.com/weechat/scripts/raw/1e3caac903e0d7873ca76ae7d2451ba5493661de/python/colorize_nicks.py";
    hash = "sha256-JOvJuagK7810a/bhEdTm6UGgSTfmHCGWXZC0lYVcjU4=";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/share
    cp $src $out/share/colorize_nicks.py
  '';

  passthru = {
    scripts = [ "colorize_nicks.py" ];
  };

  meta = {
    inherit (weechat.meta) platforms;
    description = "Use the weechat nick colors in the chat area";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ qyliss ];
  };
}
