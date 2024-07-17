{
  lib,
  stdenv,
  fetchFromGitHub,
  testers,
  vpcs,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vpcs";
  version = "0.8.3";

  src = fetchFromGitHub {
    owner = "GNS3";
    repo = "vpcs";
    rev = "v${finalAttrs.version}";
    hash = "sha256-OKi4sC4fmKtkJkkpHZ6OfeIDaBafVrJXGXh1R6gLPFY=";
  };

  sourceRoot = "${finalAttrs.src.name}/src";

  buildPhase = ''
    runHook preBuild

    MKOPT="CC=${stdenv.cc.targetPrefix}cc" ./mk.sh ${stdenv.buildPlatform.linuxArch}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -D -m555 vpcs $out/bin/vpcs
    install -D -m444 ../man/vpcs.1 $out/share/man/man1/vpcs.1

    runHook postInstall
  '';

  enableParallelBuilding = true;

  passthru = {
    tests.version = testers.testVersion {
      package = vpcs;
      command = "vpcs -v";
    };
  };

  meta = with lib; {
    description = "A simple virtual PC simulator";
    longDescription = ''
      The VPCS (Virtual PC Simulator) can simulate up to 9 PCs. You can
      ping/traceroute them, or ping/traceroute the other hosts/routers from the
      VPCS when you study the Cisco routers in the dynamips.
    '';
    inherit (finalAttrs.src.meta) homepage;
    license = licenses.bsd2;
    platforms = platforms.linux ++ platforms.darwin;
    mainProgram = "vpcs";
    maintainers = with maintainers; [ anthonyroussel ];
  };
})
