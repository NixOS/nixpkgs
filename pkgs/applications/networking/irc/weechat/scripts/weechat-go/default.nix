{
  lib,
  stdenv,
  fetchurl,
  weechat,
}:

stdenv.mkDerivation {
  pname = "weechat-go";
  version = "2.7";

  src = fetchurl {
    url = "https://github.com/weechat/scripts/raw/414cff3ee605ba204b607742430a21443c035b08/python/go.py";
    hash = "sha256-lbMy+yru5od+NRV4sCYlhCImVeEqwBkX/548HOR1yy4=";
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
