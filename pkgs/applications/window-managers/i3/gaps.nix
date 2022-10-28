{ fetchFromGitHub, lib, i3 }:

i3.overrideAttrs (oldAttrs : rec {
  pname = "i3-gaps";
  version = "4.21.1";

  src = fetchFromGitHub {
    owner = "Airblader";
    repo = "i3";
    rev = version;
    sha256 = "sha256-+JxJjvzEuAA4CH+gufzAzIqd5BSvHtPvLm2zTfXc/xk=";
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
