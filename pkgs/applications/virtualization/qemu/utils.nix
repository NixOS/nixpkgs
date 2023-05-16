<<<<<<< HEAD
{ stdenv, installShellFiles, qemu_kvm, removeReferencesTo }:

stdenv.mkDerivation rec {
  pname = "qemu-utils";
  inherit (qemu_kvm) version;

  nativeBuildInputs = [ installShellFiles ];
  buildInputs = [ qemu_kvm ];
  disallowedRequisites = [ qemu_kvm ];
=======
{ stdenv, installShellFiles, qemu, removeReferencesTo }:

stdenv.mkDerivation rec {
  pname = "qemu-utils";
  inherit (qemu) version;

  nativeBuildInputs = [ installShellFiles ];
  buildInputs = [ qemu ];
  disallowedRequisites = [ qemu ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  unpackPhase = "true";

  installPhase = ''
    mkdir -p "$out/bin"
<<<<<<< HEAD
    cp "${qemu_kvm}/bin/qemu-img" "$out/bin/qemu-img"
    cp "${qemu_kvm}/bin/qemu-io"  "$out/bin/qemu-io"
    cp "${qemu_kvm}/bin/qemu-nbd" "$out/bin/qemu-nbd"
    ${removeReferencesTo}/bin/remove-references-to -t ${qemu_kvm} $out/bin/*

    installManPage ${qemu_kvm}/share/man/man1/qemu-img.1.gz
    installManPage ${qemu_kvm}/share/man/man8/qemu-nbd.8.gz
  '';

  inherit (qemu_kvm) meta;
=======
    cp "${qemu}/bin/qemu-img" "$out/bin/qemu-img"
    cp "${qemu}/bin/qemu-io"  "$out/bin/qemu-io"
    cp "${qemu}/bin/qemu-nbd" "$out/bin/qemu-nbd"
    ${removeReferencesTo}/bin/remove-references-to -t ${qemu} $out/bin/*

    installManPage ${qemu}/share/man/man1/qemu-img.1.gz
    installManPage ${qemu}/share/man/man8/qemu-nbd.8.gz
  '';

  inherit (qemu) meta;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}
