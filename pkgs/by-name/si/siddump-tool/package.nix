{
  lib,
  stdenv,
  fetchFromGitHub,
  unstableGitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  __structuredAttrs = true;
  strictDeps = true;

  pname = "siddump-tool";
  version = "0-unstable-2024-02-23";

  src = fetchFromGitHub {
    owner = "beachviking";
    repo = "siddump-tool";
    rev = "3a0d09594116dc43751f054a5b3982c2da33cebc";
    hash = "sha256-sU30U4Q+eetI/92dbePWDZwBVbnpOdgHKsPkqG5ZlZA=";
  };

  # Upstream ships no build system, just two translation units.
  buildPhase = ''
    runHook preBuild

    $CXX -O2 -o siddump cpu.cpp siddump.cpp

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 siddump $out/bin/siddump

    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    # siddump has no --version flag and exits 1 when it prints usage.
    usage="$($out/bin/siddump 2>&1 || true)"
    echo "$usage" | grep -q "Usage: SIDDUMP"

    runHook postInstallCheck
  '';

  passthru.updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };

  meta = {
    description = "SID register dumper for C64 audio";
    longDescription = ''
      Adds functionality on top of the original SIDDump created by
      Lasse Oorni and Stein Pedersen, including output modes (-m) for
      writing the SID registers of every frame to a binary file or a
      C include file.
    '';
    homepage = "https://github.com/beachviking/siddump-tool";
    # Larsen's additions are MIT; the SIDDump core it builds on is BSD-3.
    license = [
      lib.licenses.mit
      lib.licenses.bsd3
    ];
    mainProgram = "siddump";
    maintainers = with lib.maintainers; [ ellyxir ];
    platforms = lib.platforms.unix;
  };
})
