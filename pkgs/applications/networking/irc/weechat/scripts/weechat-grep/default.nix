{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation {
  pname = "weechat-grep";
  version = "0.8.6";

  src = fetchurl {
    url = "https://github.com/weechat/scripts/raw/1e3caac903e0d7873ca76ae7d2451ba5493661de/python/grep.py";
    hash = "sha256-qxa3HxvoLhGffnfXVCrvRWE5h9vHsXuegPx6hYJ5WV0=";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/share
    cp $src $out/share/grep.py
  '';

  passthru = {
    scripts = [ "grep.py" ];
  };

  meta = {
    description = "Search in Weechat buffers and logs (for Weechat 0.3.*)";
    homepage = "https://github.com/weechat/scripts/blob/master/python/grep.py";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ flokli ];
  };
}
