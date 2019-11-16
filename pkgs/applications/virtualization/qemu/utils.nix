{ stdenv, qemu }:

stdenv.mkDerivation rec {
  name = "qemu-utils-${version}";
  version = qemu.version;

  buildInputs = [ qemu ];
  unpackPhase = "true";

  installPhase = ''
    mkdir -p "$out/bin"
    cp "${qemu}/bin/qemu-img" "$out/bin/qemu-img"
    cp "${qemu}/bin/qemu-io"  "$out/bin/qemu-io"
    cp "${qemu}/bin/qemu-nbd" "$out/bin/qemu-nbd"
  '';
}
