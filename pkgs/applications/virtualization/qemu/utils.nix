{ stdenv, installShellFiles, qemu_kvm, removeReferencesTo }:

stdenv.mkDerivation rec {
  pname = "qemu-utils";
  inherit (qemu_kvm) version;

  nativeBuildInputs = [ installShellFiles ];
  buildInputs = [ qemu_kvm ];
  disallowedRequisites = [ qemu_kvm ];
  unpackPhase = "true";

  installPhase = ''
    mkdir -p "$out/bin"
    cp "${qemu_kvm}/bin/qemu-img" "$out/bin/qemu-img"
    cp "${qemu_kvm}/bin/qemu-io"  "$out/bin/qemu-io"
    cp "${qemu_kvm}/bin/qemu-nbd" "$out/bin/qemu-nbd"
    ${removeReferencesTo}/bin/remove-references-to -t ${qemu_kvm} $out/bin/*

    installManPage ${qemu_kvm}/share/man/man1/qemu-img.1.gz
    installManPage ${qemu_kvm}/share/man/man8/qemu-nbd.8.gz
  '';

  inherit (qemu_kvm) meta;
}
