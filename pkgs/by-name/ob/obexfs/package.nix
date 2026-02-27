{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  bluez,
  fuse,
  obexftp,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "obexfs";
  version = "0.12";

  src = fetchurl {
    url = "mirror://sourceforge/openobex/obexfs-${finalAttrs.version}.tar.gz";
    sha256 = "1g3krpygk6swa47vbmp9j9s8ahqqcl9ra8r25ybgzv2d9pmjm9kj";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    fuse
    obexftp
    bluez
  ];

  meta = {
    homepage = "http://dev.zuckschwerdt.org/openobex/wiki/ObexFs";
    description = "Tool to mount OBEX-based devices (such as Bluetooth phones)";
    platforms = lib.platforms.linux;
    license = lib.licenses.lgpl2Plus;
  };
})
