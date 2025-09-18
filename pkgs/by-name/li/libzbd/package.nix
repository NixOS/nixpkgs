{
  lib,
  stdenv,
  autoconf-archive,
  autoreconfHook,
  fetchFromGitHub,
  gtk3,
  libtool,
  pkg-config,
  guiSupport ? false,
}:

stdenv.mkDerivation rec {
  pname = "libzbd";
  version = "2.0.4";

  src = fetchFromGitHub {
    owner = "westerndigitalcorporation";
    repo = "libzbd";
    rev = "v${version}";
    sha256 = "sha256-iMQjOWsgsS+uI8mqoOXHRAV1+SIu1McUAcrsY+/zcu8=";
  };

  nativeBuildInputs = [
    autoconf-archive # this can be removed with the next release
    autoreconfHook
    libtool
  ]
  ++ lib.optionals guiSupport [ pkg-config ];

  buildInputs = lib.optionals guiSupport [ gtk3 ];

  configureFlags = lib.optional guiSupport "--enable-gui";

  meta = with lib; {
    description = "Zoned block device manipulation library and tools";
    mainProgram = "zbd";
    homepage = "https://github.com/westerndigitalcorporation/libzbd";
    maintainers = [ ];
    license = with licenses; [
      lgpl3Plus
      gpl3Plus
    ];
    platforms = platforms.linux;
  };
}
