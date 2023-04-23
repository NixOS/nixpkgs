{ stdenv, installShellFiles, qemu, removeReferencesTo }:

stdenv.mkDerivation rec {
  pname = "qemu-utils";
  inherit (qemu) version;

  nativeBuildInputs = [ installShellFiles ];
  buildInputs = [ qemu ];
  disallowedRequisites = [ qemu ];
  unpackPhase = "true";

  installPhase = ''
    mkdir -p "$out/bin"
    cp "${qemu}/bin/qemu-img" "$out/bin/qemu-img"
    cp "${qemu}/bin/qemu-io"  "$out/bin/qemu-io"
    cp "${qemu}/bin/qemu-nbd" "$out/bin/qemu-nbd"
    ${removeReferencesTo}/bin/remove-references-to -t ${qemu} $out/bin/*

    installManPage ${qemu}/share/man/man1/qemu-img.1.gz
    installManPage ${qemu}/share/man/man8/qemu-nbd.8.gz
  '';

  inherit (qemu) meta;
}
