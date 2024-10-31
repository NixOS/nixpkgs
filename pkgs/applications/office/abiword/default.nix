{ lib
, stdenv
, fetchFromGitLab
, fetchpatch
, autoreconfHook269
, autoconf-archive
, pkg-config
, gtk3
, fribidi
, libpng
, popt
, libgsf
, enchant
, wv
, librsvg
, bzip2
, libjpeg
, perl
, boost
, libxslt
, goffice
, wrapGAppsHook3
}:

stdenv.mkDerivation rec {
  pname = "abiword";
  version = "3.0.5";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "AbiWord";
    rev = "refs/tags/release-${version}";
    hash = "sha256-Z55qPm4MYwbG8bvXpX2TH8bxQaJjvb3Em1ymM1XwGqo=";
  };

  patches = [
    # Fix build with libxml2 2.12
    (fetchpatch {
      url = "https://gitlab.gnome.org/World/AbiWord/-/commit/2a06be6a10a0718f8a3d8e00c317f5042c99a467.patch";
      hash = "sha256-vfh81tGXe9dgnjcAtoWHOK8CtW7MZ75FFjnfKTkiKkk=";
    })
  ];

  nativeBuildInputs = [
    autoreconfHook269
    autoconf-archive
    pkg-config
    wrapGAppsHook3
    perl
  ];

  buildInputs = [
    gtk3
    librsvg
    bzip2
    fribidi
    libpng
    popt
    libgsf
    enchant
    wv
    libjpeg
    boost
    libxslt
    goffice
  ];

  strictDeps = true;
  enableParallelBuilding = true;

  postPatch = ''
    patchShebangs ./tools/cdump/xp/cdump.pl ./po/ui-backport.pl
  '';

  preAutoreconf = ''
    ./autogen-common.sh
  '';

  meta = with lib; {
    description = "Word processing program, similar to Microsoft Word";
    mainProgram = "abiword";
    homepage = "https://gitlab.gnome.org/World/AbiWord/";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pSub ylwghst sna ];
  };
}
