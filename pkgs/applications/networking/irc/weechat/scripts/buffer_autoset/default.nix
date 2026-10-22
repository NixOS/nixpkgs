{
  lib,
  stdenv,
  fetchurl,
  weechat,
}:

stdenv.mkDerivation {
  pname = "buffer_autoset";
  version = "1.2";

  src = fetchurl {
    url = "https://raw.githubusercontent.com/weechat/scripts/2b308b44df39ba6563d02b2bcd40c384ec2777dc/python/buffer_autoset.py";
    hash = "sha256-IdIe3/ndXX3LKt1JoYhQIdlNDxl9KW5kwKvJeJ0eVDM=";
  };

  dontUnpack = true;

  passthru.scripts = [ "buffer_autoset.py" ];

  installPhase = ''
    install -D $src $out/share/buffer_autoset.py
  '';

  meta = {
    inherit (weechat.meta) platforms;
    description = "WeeChat script which auto-set buffer properties when a buffer is opened";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ govanify ];
  };
}
