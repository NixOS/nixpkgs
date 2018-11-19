{ runCommand, qemu }:


runCommand "qemu-ga-${qemu.version}" { } ''
  install -Dm555 ${qemu}/bin/qemu-ga                      $out/bin/qemu-ga
  install -Dm444 ${qemu}/share/man/man7/qemu-ga-ref.7.gz  $out/share/man/man7/qemu-ga-ref.7.gz
  install -Dm444 ${qemu}/share/man/man8/qemu-ga.8.gz      $out/share/man/man8/qemu-ga.8.gz
  install -Dm444 ${qemu}/share/doc/qemu-ga-ref.txt        $out/share/doc/qemu-ga-ref.txt
  install -Dm444 ${qemu}/share/doc/qemu-ga-ref.html       $out/share/doc/qemu-ga-ref.html
''
