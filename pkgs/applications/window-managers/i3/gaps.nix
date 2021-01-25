{ fetchurl, lib, i3, autoreconfHook }:

i3.overrideAttrs (oldAttrs : rec {

  name = "i3-gaps-${version}";
  version = "4.19";

  src = fetchurl {
    url = "https://github.com/Airblader/i3/releases/download/${version}/i3-${version}.tar.xz";
    sha256 = "0j19kj05fpjfnj50vyykk6jsr07hq9l26y8na55bb7yfrra8yp4h";
  };

  meta = with lib; {
    description = "A fork of the i3 tiling window manager with some additional features";
    homepage    = "https://github.com/Airblader/i3";
    maintainers = with maintainers; [ fmthoma ];
    license     = licenses.bsd3;
    platforms   = platforms.linux ++ platforms.netbsd ++ platforms.openbsd;

    longDescription = ''
      Fork of i3wm, a tiling window manager primarily targeted at advanced users
      and developers. Based on a tree as data structure, supports tiling,
      stacking, and tabbing layouts, handled dynamically, as well as floating
      windows. This fork adds a few features such as gaps between windows.
      Configured via plain text file. Multi-monitor. UTF-8 clean.
    '';
  };
})
