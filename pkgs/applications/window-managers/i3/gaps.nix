{ fetchurl, stdenv, i3, autoreconfHook }:

i3.overrideAttrs (oldAttrs : rec {

  name = "i3-gaps-${version}";
  version = "4.18";
  releaseDate = "2019-01-27";

  src = fetchurl {
    url = "https://github.com/Airblader/i3/archive/${version}.tar.gz";
    sha256 = "04sq2sik7j09kgnn1k87yg3vzy56pk4688bmxh49l6drl0wr1m2v";
  };

  nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [ autoreconfHook ];

  postUnpack = ''
      echo -n "${version} (${releaseDate})" > ./i3-${version}/I3_VERSION
  '';

  # fatal error: GENERATED_config_enums.h: No such file or directory
  enableParallelBuilding = false;

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
})
