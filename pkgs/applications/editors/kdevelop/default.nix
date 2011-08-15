{ stdenv, fetchurl, kdevplatform, cmake, pkgconfig, automoc4, shared_mime_info,
  kdebase_workspace, gettext, perl, kdeutils, kdesdk }:

let
  okteta = if kdeutils ? okteta then kdeutils.okteta else kdesdk.okteta;
in
stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  version = "4.2.3";
  pname = "kdevelop";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${version}/src/${name}.tar.bz2";
    sha256 = "0ay3d2s5442pvdsx9lyfzb986kh6848qhbls9ff982f0glzqdcya";
  };

  buildInputs = [ kdevplatform cmake pkgconfig automoc4 shared_mime_info
    kdebase_workspace gettext stdenv.gcc.libc perl okteta ];

  NIX_CFLAGS_COMPILE = "-I${okteta}/include/KDE";

  meta = with stdenv.lib; {
    maintainers = [ maintainers.urkud ];
    platforms = platforms.linux;
    description = "KDE official IDE";
    longDescription =
      ''
        A free, opensource IDE (Integrated Development Environment)
        for MS Windows, Mac OsX, Linux, Solaris and FreeBSD. It is a
        feature-full, plugin extendable IDE for C/C++ and other
        programing languages. It is based on KDevPlatform, KDE and Qt
        libraries and is under development since 1998.
      '';
    homepage = http://www.kdevelop.org;
  };
}
