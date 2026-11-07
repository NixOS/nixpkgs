{
  stdenv,
  lib,
  fetchurl,
  weechat,
}:

stdenv.mkDerivation {
  pname = "weechat-colorize_nicks";
  version = "27";

  src = fetchurl {
    url = "https://github.com/weechat/scripts/raw/bc8a9051800779a036ba11689a277cd5f03657b2/python/colorize_nicks.py";
    hash = "sha256-umuxcwoTm60vqrVC3h3V+qwbQaUOKoOjDCf4vRHyKkI=";
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
