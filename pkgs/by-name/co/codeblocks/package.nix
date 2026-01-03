{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  pkg-config,
  file,
  zip,
  wxGTK32,
  gtk3,
  contribPlugins ? false,
  hunspell,
  boost,
  wrapGAppsHook3,
}:

stdenv.mkDerivation rec {
  name = "${pname}-${lib.optionalString contribPlugins "full-"}${version}";
  pname = "codeblocks";
  version = "25.03";

  src = fetchurl {
    url = "mirror://sourceforge/codeblocks/Sources/${version}/codeblocks_${version}.tar.xz";
    hash = "sha256-sPaqWQjTNtf0H5V2skGKx9J++8WSgqqMkXHYjOp0BJ4=";
  };

  nativeBuildInputs = [
    pkg-config
    file
    zip
    wrapGAppsHook3
  ];

  buildInputs = [
    wxGTK32
    gtk3
  ]
  ++ lib.optionals contribPlugins [
    hunspell
    boost
  ];

  enableParallelBuilding = true;

  patches = [ ./writable-projects.patch ];

  preConfigure = "substituteInPlace ./configure --replace-fail /bin/file ${file}/bin/file";

  postConfigure = lib.optionalString stdenv.hostPlatform.isLinux "substituteInPlace libtool --replace ldconfig ${stdenv.cc.libc.bin}/bin/ldconfig";

  configureFlags = [
    "--enable-pch=no"
  ]
  ++ lib.optionals contribPlugins [
    (
      "--with-contrib-plugins=all,-FileManager"
      + lib.optionalString stdenv.hostPlatform.isDarwin ",-NassiShneiderman"
    )
    "--with-boost-libdir=${boost}/lib"
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    ln -s $out/lib/codeblocks/plugins $out/share/codeblocks/plugins
  '';

  meta = {
    maintainers = [ ];
    platforms = lib.platforms.all;
    description = "Open source, cross platform, free C, C++ and Fortran IDE";
    longDescription = ''
      Code::Blocks is a free C, C++ and Fortran IDE built to meet the most demanding needs of its users.
      It is designed to be very extensible and fully configurable.
      Finally, an IDE with all the features you need, having a consistent look, feel and operation across platforms.
    '';
    homepage = "http://www.codeblocks.org";
    license = lib.licenses.gpl3;
  };
}
