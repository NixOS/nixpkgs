{
  lib,
  stdenv,
  fetchFromGitHub,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "apfsprogs";
  version = "0-unstable-2024-09-27";

  src = fetchFromGitHub {
    owner = "linux-apfs";
    repo = "apfsprogs";
    rev = "f31d7c2d69d212ce381399d2bb1e91410f592484";
    hash = "sha256-+c+wU52XKNOTxSpSrkrNWoGEYw6Zo4CGEOyKMvkXEa0=";
  };

  postPatch =
    let
      shortRev = builtins.substring 0 9 finalAttrs.src.rev;
    in
    ''
      substituteInPlace \
        apfs-snap/Makefile apfsck/Makefile mkapfs/Makefile apfs-label/Makefile \
        --replace-fail \
          '$(shell git describe --always HEAD | tail -c 9)' \
          '${shortRev}'
    '';

  buildPhase = ''
    runHook preBuild
    make -C apfs-snap $makeFlags
    make -C apfsck $makeFlags
    make -C mkapfs $makeFlags
    make -C apfs-label $makeFlags
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    make -C apfs-snap install DESTDIR="$out" $installFlags
    make -C apfsck install DESTDIR="$out" $installFlags
    make -C mkapfs install DESTDIR="$out" $installFlags
    make -C apfs-label install DESTDIR="$out" $installFlags
    runHook postInstall
  '';

  passthru.tests = {
    apfs = nixosTests.apfs;
  };

  strictDeps = true;

  meta = with lib; {
    description = "Experimental APFS tools for linux";
    homepage = "https://github.com/linux-apfs/apfsprogs";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ Luflosi ];
  };
})
