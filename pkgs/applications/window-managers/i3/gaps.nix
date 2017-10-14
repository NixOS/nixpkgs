{ fetchurl, stdenv, i3, autoreconfHook }:

i3.overrideDerivation (super : rec {

  name = "i3-gaps-${version}";
  version = "4.14.1";
  releaseDate = "2017-09-24";

  src = fetchurl {
    url = "https://github.com/Airblader/i3/archive/${version}.tar.gz";
    sha256 = "11fnkg4halplcnannfw3ishzwwbxbnjafmkxsim199jhlyjjd8j7";
  };

  nativeBuildInputs = super.nativeBuildInputs ++ [ autoreconfHook ];

  postUnpack = ''
      echo -n "${version} (${releaseDate})" > ./i3-${version}/I3_VERSION
  '';

  # fatal error: GENERATED_config_enums.h: No such file or directory
  enableParallelBuilding = false;
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
