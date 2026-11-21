{
  lib,
  stdenv,
  fetchurl,
  weechat,
}:

stdenv.mkDerivation {
  pname = "weechat-go";
  version = "3.1.1";

  src = fetchurl {
    url = "https://github.com/weechat/scripts/raw/1e3caac903e0d7873ca76ae7d2451ba5493661de/python/go.py";
    hash = "sha256-dAq5Lb+CNa//QfOry0NVPBUahu8o1jX1EfsTIMhYffo=";
  };

  dontUnpack = true;

  passthru.scripts = [ "go.py" ];

  installPhase = ''
    install -D $src $out/share/go.py
  '';

  meta = {
    inherit (weechat.meta) platforms;
    description = "WeeChat script to quickly jump to different buffers";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ govanify ];
  };
}
