{ lib
, stdenv
, fetchFromGitHub
, nixosTests
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "apfsprogs";
  version = "unstable-2023-11-30";

  src = fetchFromGitHub {
    owner = "linux-apfs";
    repo = "apfsprogs";
    rev = "990163894d871f51ba102a75aed384a275c5991b";
    hash = "sha256-yCShZ+ALzSe/svErt9/i1JyyEvbIeABGPbpS4lVil0A=";
  };

  postPatch = let
    shortRev = builtins.substring 0 9 finalAttrs.src.rev;
  in ''
    substituteInPlace \
      apfs-snap/Makefile apfsck/Makefile mkapfs/Makefile \
      --replace-fail \
        '$(shell git describe --always HEAD | tail -c 9)' \
        '${shortRev}'
  '';

  buildPhase = ''
    runHook preBuild
    make -C apfs-snap $makeFlags
    make -C apfsck $makeFlags
    make -C mkapfs $makeFlags
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    make -C apfs-snap install DESTDIR="$out" $installFlags
    make -C apfsck install DESTDIR="$out" $installFlags
    make -C mkapfs install DESTDIR="$out" $installFlags
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
