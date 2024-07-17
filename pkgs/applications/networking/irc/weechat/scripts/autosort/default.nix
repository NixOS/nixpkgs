{
  lib,
  stdenv,
  fetchurl,
  weechat,
}:

stdenv.mkDerivation {
  pname = "weechat-autosort";
  version = "3.10";

  src = fetchurl {
    url = "https://github.com/weechat/scripts/raw/13aef991ca879fc0ff116874a45b09bc2db10607/python/autosort.py";
    hash = "sha256-xuZUssjGd0l7lCx96d0V8LL+0O3zIxYlWMoDsdzwMf4=";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/share
    cp $src $out/share/autosort.py
  '';

  passthru = {
    scripts = [ "autosort.py" ];
  };

  meta = with lib; {
    inherit (weechat.meta) platforms;
    description = "autosort automatically keeps your buffers sorted and grouped by server.";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ flokli ];
  };
}
