{ lib
, stdenvNoCC
, fetchFromGitea

, glibc
, help2man
, installShellFiles
, makeWrapper
, patsh

, apt
, coreutils
, dpkg
, fakechroot
, fakeroot
, findutils
, gnupg
, gnutar
, perl
, python3
, shadow
, util-linux

, mmdebstrap
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "mmdebstrap";
  version = "1.4.0";

  src = fetchFromGitea {
    domain = "gitlab.mister-muffin.de";
    owner = "josch";
    repo = "mmdebstrap";
    rev = "${finalAttrs.version}";
    hash = "sha256-ulW+zCYVMqi6wzqPYYlTsKZqgW9DmClTFJdEMRY4yiI=";
  };

  nativeBuildInputs = [
    glibc
    help2man
    installShellFiles
    makeWrapper
    patsh
  ];

  buildInputs = [
    perl
    python3
  ];

  buildPhase = ''
    runHook preBuild

    patchShebangs ./tarfilter
    patsh -f ./mmdebstrap-autopkgtest-build-qemu -s ${builtins.storeDir}

    pod2man ./mmdebstrap > ./mmdebstrap.1
    pod2man ./mmdebstrap-autopkgtest-build-qemu > ./mmdebstrap-autopkgtest-build-qemu.1
    help2man --no-info --name "filter a tarball like dpkg does" --version-string="${finalAttrs.version}" ./tarfilter > ./tarfilter.1

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin/
    mv mmdebstrap $out/bin/
    mv mmdebstrap-autopkgtest-build-qemu $out/bin/
    mv tarfilter $out/bin/mmtarfilter

    installManPage *.1

    mkdir -p $out/lib/apt/solvers/
    mv proxysolver $out/lib/apt/solvers/mmdebstrap-dump-solution

    mkdir -p $out/share/mmdebstrap
    mv hooks/ $out/share/mmdebstrap/

    mkdir -p $out/share/doc/mmdebstrap/
    mv examples/ $out/share/doc/mmdebstrap/

    mkdir -p $out/share/libexec/mmdebstrap/
    mv gpgvnoexpkeysig $out/share/libexec/mmdebstrap/
    mv ldconfig.fakechroot $out/share/libexec/mmdebstrap/

    wrapProgram $out/bin/mmdebstrap \
      --suffix PERL5LIB : $out/include \
      --set PATH ${lib.makeBinPath [
        "$out" apt coreutils dpkg fakechroot fakeroot
               findutils gnupg gnutar shadow util-linux
      ]}

    headers=(
      syscall.h sys/syscall.h asm/unistd.h asm/unistd_32.h asm/unistd_64.h bits/wordsize.h bits/syscall.h
      sys/ioctl.h features.h features-time64.h bits/timesize.h stdc-predef.h sys/cdefs.h bits/long-double.h
      gnu/stubs.h gnu/stubs-64.h bits/ioctls.h asm/ioctls.h asm-generic/ioctls.h linux/ioctl.h asm/ioctl.h
      asm-generic/ioctl.h bits/ioctl-types.h sys/ttydefaults.h
    )
    for h in "''${headers[@]}"
    do
      h2ph -d $out ${glibc.dev}/include/$h
      mkdir -p $out/include/$(dirname $h)
      mv $out/${glibc.dev}/include/''${h%.h}.ph $out/include/$(dirname $h)
    done
    mv $out/_h2ph_pre.ph $out/include/
    rm -rf $out/${glibc.dev}

    runHook postInstall
  '';

  meta = with lib; {
    changelog = "https://gitlab.mister-muffin.de/josch/mmdebstrap/src/tag/${finalAttrs.version}/CHANGELOG.md";
    description = "An alternative to debootstrap which uses apt internally";
    homepage = "https://gitlab.mister-muffin.de/josch/mmdebstrap";
    license = with lib.licenses; [ mit publicDomain ];
    maintainers = with maintainers; [ MakiseKurisu ];
    mainProgram = "mmdebstrap";
    platforms = platforms.linux;
  };
})
