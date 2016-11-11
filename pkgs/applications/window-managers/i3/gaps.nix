{ fetchurl, stdenv, i3, autoreconfHook }:

i3.overrideDerivation (super : rec {

  name = "i3-gaps-${version}";
  version = "4.13";
  releaseDate = "2016-11-08";

  src = fetchurl {
    url = "https://github.com/Airblader/i3/archive/${version}.tar.gz";
    sha256 = "0w959nx2crn00fckqwb5y78vcr1j9mvq5lh25wyjszx04pjhf378";
  };

  nativeBuildInputs = super.nativeBuildInputs ++ [ autoreconfHook ];

  postUnpack = ''
      echo -n "${version} (${releaseDate})" > ./i3-${version}/I3_VERSION
  '';

}) // {

  meta = with stdenv.lib; {
    description = "A fork of the i3 tiling window manager with some additional features";
    homepage    = "https://github.com/Airblader/i3";
    maintainers = with maintainers; [ fmthoma ];
    license     = licenses.bsd3;
    platforms   = platforms.all;

    longDescription = ''
      Fork of i3wm, a tiling window manager primarily targeted at advanced users
      and developers. Based on a tree as data structure, supports tiling,
      stacking, and tabbing layouts, handled dynamically, as well as floating
      windows. This fork adds a few features such as gaps between windows.
      Configured via plain text file. Multi-monitor. UTF-8 clean.
    '';
  };

}
