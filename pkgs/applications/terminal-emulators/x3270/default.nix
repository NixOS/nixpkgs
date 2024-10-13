{ stdenv
, darwin
, lib
, libiconv
, fetchurl
, m4
, expat
, libX11
, libXt
, libXaw
, libXmu
, bdftopcf
, mkfontdir
, fontadobe100dpi
, fontadobeutopia100dpi
, fontbh100dpi
, fontbhlucidatypewriter100dpi
, fontbitstream100dpi
, tcl
, ncurses
, openssl
, readline
}:
let
  majorVersion = "4";
  minorVersion = "3";
  versionSuffix = "ga8";
in
stdenv.mkDerivation rec {
  pname = "x3270";
  version = "${majorVersion}.${minorVersion}${versionSuffix}";

  src = fetchurl {
    url =
      "http://x3270.bgp.nu/download/0${majorVersion}.0${minorVersion}/suite3270-${version}-src.tgz";
    sha256 = "sha256-gcC6REfZentIPEDhGznUSYu8mvVfpPeMz/Bks+N43Fk=";
  };

  buildFlags = lib.optional stdenv.hostPlatform.isLinux "unix";

  configureFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    "--enable-c3270"
    "--enable-pr3270"
    "--enable-s3270"
    "--enable-tcl3270"
  ];

  postBuild = ''
    make install.man
  '';

  pathsToLink = [ "/share/man" ];

  nativeBuildInputs = [ m4 ];
  buildInputs = [
    expat
    libX11
    libXt
    libXaw
    libXmu
    bdftopcf
    mkfontdir
    fontadobe100dpi
    fontadobeutopia100dpi
    fontbh100dpi
    fontbhlucidatypewriter100dpi
    fontbitstream100dpi
    tcl
    ncurses
    expat
    openssl
    readline
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ libiconv darwin.apple_sdk.frameworks.Security ];

  meta = with lib; {
    description = "IBM 3270 terminal emulator for the X Window System";
    homepage = "http://x3270.bgp.nu/index.html";
    license = licenses.bsd3;
    maintainers = [ maintainers.anna328p ];
  };
}
