{ stdenv, lib, fetchurl, pkg-config, systemd, libobjc, IOKit, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "libusb";
  version = "1.0.19";

  src = fetchurl {
    url = "mirror://sourceforge/libusb/libusb-${version}.tar.bz2";
    sha256 = "0h38p9rxfpg9vkrbyb120i1diq57qcln82h5fr7hvy82c20jql3c";
  };

  outputs = [ "out" "dev" ]; # get rid of propagating systemd closure

  buildInputs = [ pkg-config ];
  propagatedBuildInputs = lib.optional stdenv.isLinux systemd
    ++ lib.optionals stdenv.isDarwin [ libobjc IOKit ];

  patches = [
    (fetchpatch {
      name = "libusb.stdfu.patch";
      url = "https://raw.githubusercontent.com/axoloti/axoloti/1.0.12/platform_linux/src/libusb.stdfu.patch";
      sha256 = "194j7j61i4q6x0ihm9ms8dxd4vliw20n2rj6cm9h17qzdl9xr33d";
    })
  ];

  NIX_LDFLAGS = lib.optionalString stdenv.isLinux "-lgcc_s";

  preFixup = lib.optionalString stdenv.isLinux ''
    sed 's,-ludev,-L${lib.getLib systemd}/lib -ludev,' -i $out/lib/libusb-1.0.la
  '';

  meta = with lib; {
    homepage = "http://www.libusb.info";
    description = "User-space USB library";
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
    license = licenses.lgpl21;
  };
}
