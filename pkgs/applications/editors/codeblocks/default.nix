{ lib, stdenv, fetchurl, pkg-config, file, zip, wxGTK30-gtk3, gtk3
, contribPlugins ? false, hunspell, gamin, boost, wrapGAppsHook
}:

with lib;

stdenv.mkDerivation rec {
  name = "${pname}-${lib.optionalString contribPlugins "full-"}${version}";
  version = "20.03";
  pname = "codeblocks";

  src = fetchurl {
    url = "mirror://sourceforge/codeblocks/Sources/${version}/codeblocks-${version}.tar.xz";
    sha256 = "1idaksw1vacmm83krxh5zlb12kad3dkz9ixh70glw1gaibib7vhm";
  };

  nativeBuildInputs = [ pkg-config file zip wrapGAppsHook ];
  buildInputs = [ wxGTK30-gtk3 gtk3 ]
    ++ optionals contribPlugins [ hunspell gamin boost ];
  enableParallelBuilding = true;
  patches = [ ./writable-projects.patch ];
  preConfigure = "substituteInPlace ./configure --replace /usr/bin/file ${file}/bin/file";
  postConfigure = optionalString stdenv.isLinux "substituteInPlace libtool --replace ldconfig ${stdenv.cc.libc.bin}/bin/ldconfig";
  configureFlags = [ "--enable-pch=no" ]
    ++ optionals contribPlugins [ "--with-contrib-plugins" "--with-boost-libdir=${boost}/lib" ];

  meta = {
    maintainers = [ maintainers.linquize ];
    platforms = platforms.all;
    description = "The open source, cross platform, free C, C++ and Fortran IDE";
    longDescription =
      ''
        Code::Blocks is a free C, C++ and Fortran IDE built to meet the most demanding needs of its users.
        It is designed to be very extensible and fully configurable.
        Finally, an IDE with all the features you need, having a consistent look, feel and operation across platforms.
      '';
    homepage = "http://www.codeblocks.org";
    license = licenses.gpl3;
  };
}
