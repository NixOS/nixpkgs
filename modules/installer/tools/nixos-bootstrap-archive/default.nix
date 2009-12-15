args: with args;

# TODO  add revision number or such
runCommand "nixos-bootstrap-archive" { } ''
  PATH=${perl}/bin:${coreutils}/bin:${gnutar}/bin:${bzip2}/bin
  storePaths=$(perl ${pathsFromGraph} ${nixClosure})

  s(){ echo -C $(dirname $1) $(basename $1); }

  mkdir $out
  tar cf tmp.tar ${nixClosure} $storePaths 
  cp ${./README-BOOTSTRAP-NIXOS} README-BOOTSTRAP-NIXOS
  tar --append -f tmp.tar README-BOOTSTRAP-NIXOS
  tar --append -f tmp.tar --transform 's@^@/nix/store/@' \
      $(s ${nixosPrepareInstall}/bin/nixos-prepare-install ) \
      $(s ${runInChroot}/bin/run-in-chroot ) \
      $(s ${nixosBootstrap}/bin/nixos-bootstrap )
      
  cat tmp.tar | bzip2 > $out/nixos-install-archive.tar.bz2
''
