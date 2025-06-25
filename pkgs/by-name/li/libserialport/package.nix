{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  udev,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libserialport";
  version = "0.1.2";

  src = fetchurl {
    url = "https://sigrok.org/download/source/libserialport/libserialport-${finalAttrs.version}.tar.gz";
    hash = "sha256-XeuStcpywDR7B7eGhINQ3sotz9l1zmE7jg4dlHpLTKk=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = lib.optional stdenv.hostPlatform.isLinux udev;

  meta = {
    description = "Cross-platform shared library for serial port access";
    homepage = "https://sigrok.org/";
    license = lib.licenses.gpl3Plus;
    platforms = with lib; platforms.linux ++ platforms.darwin ++ platforms.windows;
    maintainers = [ lib.maintainers.bjornfor ];
  };
})
