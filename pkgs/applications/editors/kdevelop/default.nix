{ stdenv, fetchurl, kdevplatform, cmake, pkgconfig, automoc4, shared_mime_info,
  kdebase_workspace, gettext, perl, okteta }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  version = "4.3.1";
  pname = "kdevelop";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${version}/src/${name}.tar.bz2";
    sha256 = "0015hv39rqhyq1w6jw65lx7ls4l5pc3a2asvd5zsd65831vrfxxs";
  };

  buildInputs = [ kdevplatform kdebase_workspace okteta ];

  nativeBuildInputs = [ cmake pkgconfig automoc4 shared_mime_info gettext perl ];

  patches =
    [ ( fetchurl {
        url = https://git.reviewboard.kde.org/r/105211/diff/raw/;
        name = "okteta-0.9.patch"; # fixes build with KDE-4.9.x
        sha256 = "1mvqhw7jr1vi66l3jgam3slyfafcvwy4g3iapfi69dpfnzhmcxl0";
      } )
    ];

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
