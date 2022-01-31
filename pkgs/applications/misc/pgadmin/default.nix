{ lib, stdenv, fetchurl, fetchpatch, postgresql, wxGTK, libxml2, libxslt, openssl, zlib, makeDesktopItem }:

stdenv.mkDerivation rec {
  pname = "pgadmin3";
  version = "1.22.2";

  src = fetchurl {
    url = "https://ftp.postgresql.org/pub/pgadmin/pgadmin3/v${version}/src/pgadmin3-${version}.tar.gz";
    sha256 = "1b24b356h8z188nci30xrb57l7kxjqjnh6dq9ws638phsgiv0s4v";
  };

  enableParallelBuilding = true;

  buildInputs = [ postgresql wxGTK openssl zlib ];

  patches = [
    (fetchpatch {
      sha256 = "09hp7s3zjz80rpx2j3xyznwswwfxzi70z7c05dzrdk74mqjjpkfk";
      name = "843344.patch";
      url = "https://sources.debian.net/data/main/p/pgadmin3/1.22.2-1/debian/patches/843344";
    })
  ];

  preConfigure = ''
    substituteInPlace pgadmin/ver_svn.sh --replace "bin/bash" "$shell"
  '';

  configureFlags = [
    "--with-pgsql=${postgresql}"
    "--with-libxml2=${libxml2.dev}"
    "--with-libxslt=${libxslt.dev}"
  ];

  # starting with C++11 narrowing became an error
  # and not just a warning. With the current c++ compiler
  # pgadmin3 will fail with several "narrowing" errors.
  # see https://gcc.gnu.org/onlinedocs/gcc/C_002b_002b-Dialect-Options.html#index-Wno-narrowing
  makeFlags = "CXXFLAGS=-Wno-narrowing" ;

  meta = with lib; {
    description = "PostgreSQL administration GUI tool";
    homepage = "https://www.pgadmin.org";
    license = licenses.gpl2;
    maintainers = with maintainers; [ domenkozar wmertens ];
    platforms = platforms.unix;
  };

  postFixup = let
    desktopItem = makeDesktopItem {
      name = "pgAdmin";
      desktopName = "pgAdmin III";
      genericName = "SQL Administration";
      exec = "pgadmin3";
      icon = "pgAdmin3";
      type = "Application";
      categories = "Development;";
      mimeType = "text/html";
    };
  in ''
    mkdir -p $out/share/pixmaps;
    cp pgadmin/include/images/pgAdmin3.png $out/share/pixmaps/;
    cp -rv ${desktopItem}/share/applications $out/share/
  '';
}
