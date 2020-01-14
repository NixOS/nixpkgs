{ stdenv, fetchurl, autoreconfHook, libtool, pkgconfig, file, zip, wxGTK, gtk2
, contribPlugins ? false, hunspell, gamin, boost
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "${pname}-${stdenv.lib.optionalString contribPlugins "full-"}${version}";
  version = "17.12";
  pname = "codeblocks";

  src = fetchurl {
    url = "mirror://sourceforge/codeblocks/Sources/${version}/codeblocks_${version}.tar.xz";
    sha256 = "1q2pph7md1p10i83rir2l4gvy7ym2iw8w6sk5vl995knf851m20k";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig libtool file zip ];
  buildInputs = [ wxGTK gtk2 ]
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
    homepage = http://www.codeblocks.org;
    license = licenses.gpl3;
  };
}
