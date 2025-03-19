{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  udev,
  darwin,
}:

stdenv.mkDerivation rec {
  pname = "libserialport";
  version = "0.1.2";

  src = fetchurl {
    url = "https://sigrok.org/download/source/libserialport/${pname}-${version}.tar.gz";
    sha256 = "sha256-XeuStcpywDR7B7eGhINQ3sotz9l1zmE7jg4dlHpLTKk=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs =
    lib.optional stdenv.hostPlatform.isLinux udev
    ++ lib.optional stdenv.hostPlatform.isDarwin darwin.apple_sdk.frameworks.IOKit;

  meta = with lib; {
    description = "Cross-platform shared library for serial port access";
    homepage = "https://sigrok.org/";
    license = licenses.gpl3Plus;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = [ maintainers.bjornfor ];
  };
}
