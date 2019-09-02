{ stdenv
, lib
, fetchFromGitHub
, fetchpatch

, cmake
, gettext
, wrapGAppsHook
, pkgconfig

, glib
, gsettings-desktop-schemas
, gtk3
, hicolor-icon-theme
, libsndfile
, libxml2
, pcre
, poppler
, portaudio
, zlib

# Plugins don't appear to be working in this version, so disable them by not
# building with Lua support by default. In a future version, try switching this
# to 'true' and seeing if the top-level Plugin menu appears.
, withLua ? false, lua
}:

stdenv.mkDerivation rec {
  name = "xournalpp-${version}";
  version = "1.0.8";

  src = fetchFromGitHub {
    owner = "xournalpp";
    repo = "xournalpp";
    rev = version;
    sha256 = "01q84xjp9z1krna10gjj562km6i3wdq8cg7paxax1k6bh52ryvf6";
  };

  patches = [
    # This patch removes the unused 'xopp-recording.sh' file which breaks the
    # cmake build; this patch isn't in a release yet, and should be removed at
    # or after 1.0.9 is released.
    (fetchpatch {
      name = "remove-xopp-recording.sh.patch";
      url = "https://github.com/xournalpp/xournalpp/commit/a17a3f2c80c607a22d0fdeb66d38358bea7e4d85.patch";
      sha256 = "10pcpvklm6kr0lv2xrsbpg2037ni9j6dmxgjf56p466l3gz60iwy";
    })
  ];

  nativeBuildInputs = [ cmake gettext pkgconfig wrapGAppsHook ];
  buildInputs =
    [ glib
      gsettings-desktop-schemas
      gtk3
      hicolor-icon-theme
      libsndfile
      libxml2
      pcre
      poppler
      portaudio
      zlib
    ]
    ++ lib.optional withLua lua;

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Xournal++ is a handwriting Notetaking software with PDF annotation support";
    homepage    = https://github.com/xournalpp/xournalpp;
    license     = licenses.gpl2;
    maintainers = with maintainers; [ andrew-d ];
    platforms   = platforms.linux;
  };
}
