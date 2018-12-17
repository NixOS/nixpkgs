{ runCommand, qemu }:


runCommand "qemu-img-${qemu.version}" { } ''
  install -Dm555 ${qemu}/bin/qemu-img                     $out/bin/qemu-img
  install -Dm444 ${qemu}/share/man/man1/qemu-img.1.gz     $out/share/man/man1/qemu-img.1.gz
''
