{
  lib,
  stdenv,
  fetchurl,
  zeromq,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "4.2.1";
  pname = "czmq";

  src = fetchurl {
    url = "https://github.com/zeromq/czmq/releases/download/v${finalAttrs.version}/czmq-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-XXIKIEwqWGRdb3ZDrxXVY6cS2tmMnTLB7ZEzd9qmrDk=";
    meta.identifiers.purlParts = {
      type = "github";
      spec = "zeromq/czmq@${finalAttrs.version}";
    };
  };

  # Needs to be propagated for the .pc file to work
  propagatedBuildInputs = [ zeromq ];

  meta = {
    homepage = "http://czmq.zeromq.org/";
    description = "High-level C Binding for ZeroMQ";
    mainProgram = "zmakecert";
    license = lib.licenses.mpl20;
    platforms = lib.platforms.all;
  };
})
