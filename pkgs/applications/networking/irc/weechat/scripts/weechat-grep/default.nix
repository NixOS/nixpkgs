{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "weechat-grep";
  version = "0.8.5";

  src = fetchurl {
    url = "https://github.com/weechat/scripts/raw/5ee93d56f371c829d2798a5446a14292c180f70b/python/grep.py";
    sha256 = "sha256-EVcoxjTTjXOYD8DppD+IULxpKerEdolmlgphrulFGC0=";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/share
    cp $src $out/share/grep.py
  '';

  passthru = {
    scripts = [ "grep.py" ];
  };

  meta = with lib; {
    description = "Search in Weechat buffers and logs (for Weechat 0.3.*)";
    homepage = "https://github.com/weechat/scripts/blob/master/python/grep.py";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ flokli ];
  };
}
