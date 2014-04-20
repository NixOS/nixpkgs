{ stdenv, fetchurl, autoconf, automake, libtool, pkgconfig, file, zip, wxGTK, gtk
, contribPlugins ? false, hunspell, gamin , boost
}:

stdenv.mkDerivation rec {
  name = "${pname}-${stdenv.lib.optionalString contribPlugins "full-"}${version}";
  version = "13.12";
  pname = "codeblocks";

  src = fetchurl {
    url = "mirror://sourceforge/codeblocks/Sources/${version}/codeblocks_${version}-1.tar.gz";
    sha256 = "044njhps4cm1ijfdyr5f9wjyd0vblhrz9b4603ma52wcdq25093p";
  };

  buildInputs = [ automake autoconf libtool pkgconfig file zip wxGTK gtk ]
    ++ stdenv.lib.optionals contribPlugins [ hunspell gamin boost ];
  enableParallelBuilding = true;
  patches = [ ./writable-projects.patch ];
  preConfigure = "substituteInPlace ./configure --replace /usr/bin/file ${file}/bin/file";
  postConfigure = "substituteInPlace libtool --replace ldconfig ${stdenv.gcc.libc}/sbin/ldconfig";
  configureFlags = [ "--enable-pch=no" ]
    ++ stdenv.lib.optional contribPlugins "--with-contrib-plugins";

  meta = with stdenv.lib; {
    maintainers = [ maintainers.linquize ];
    platforms = platforms.all;
    description = "The open source, cross platform, free C, C++ and Fortran IDE";
    longDescription =
      ''
        Code::Blocks is a free C, C++ and Fortran IDE built to meet the most demanding needs of its users.
        It is designed to be very extensible and fully configurable.
        Finally, an IDE with all the features you need, having a consistent look, feel and operation across platforms.
      '';
    homepage = http://www.codeblocks.org;
    license = licenses.gpl3;
  };
}
