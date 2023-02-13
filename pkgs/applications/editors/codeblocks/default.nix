{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, autoconf
, automake
, file
, libtool
, pkg-config
, wrapGAppsHook
, zip
, gtk3
, wxGTK32
, contribPlugins ? false
, boost
, gamin
, hunspell
, unstableGitUpdater
}:

stdenv.mkDerivation rec {
  pname = "codeblocks" + lib.optionalString contribPlugins "-full";
  version = "unstable-2023-02-12";

  src = fetchFromGitHub {
    owner = "arnholm";
    repo = "codeblocks_sfmirror";
    rev = "ce0132e755554a7563d79bdb6f8719b8b9422df6";
    hash = "sha256-FoFCIvChvgIwAvjw8dw0ny30sdLMGwVtKXHCW/Z4Fwg=";
  };

  patches = [
    ./writable-projects.patch
  ];

  nativeBuildInputs = [
    autoconf
    automake
    file
    libtool
    pkg-config
    wrapGAppsHook
    zip
  ];

  buildInputs = [
    gtk3
    wxGTK32
  ] ++ lib.optionals contribPlugins [
    boost
    gamin
    hunspell
  ];

  preConfigure = ''
    ./bootstrap
  '';

  postConfigure = lib.optionalString stdenv.isLinux ''
    substituteInPlace libtool --replace ldconfig ${stdenv.cc.libc.bin}/bin/ldconfig
  '';

  configureFlags = [
    "--enable-pch=no"
  ] ++ lib.optionals contribPlugins [
    ("--with-contrib-plugins" + lib.optionalString stdenv.isDarwin "=all,-FileManager")
    "--with-boost-libdir=${boost}/lib"
  ];

  enableParallelBuilding = true;

  postInstall = lib.optionalString stdenv.isDarwin ''
    ln -s $out/lib/codeblocks/plugins $out/share/codeblocks/plugins
  '';

  passthru = {
    updateScript = unstableGitUpdater { };
  };

  meta = with lib; {
    maintainers = with maintainers; [ linquize wegank ];
    platforms = platforms.all;
    description = "The open source, cross platform, free C, C++ and Fortran IDE";
    longDescription = ''
      Code::Blocks is a free C, C++ and Fortran IDE built to meet the most demanding needs of its users.
      It is designed to be very extensible and fully configurable.
      Finally, an IDE with all the features you need, having a consistent look, feel and operation across platforms.
    '';
    homepage = "http://www.codeblocks.org";
    license = licenses.gpl3Only;
  };
}
