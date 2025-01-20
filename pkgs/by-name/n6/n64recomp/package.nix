{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  unstableGitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "n64recomp";
  version = "0-unstable-2024-09-15";

  src = fetchFromGitHub {
    owner = "N64Recomp";
    repo = "N64Recomp";
    rev = "d33d38161798167929b114c2b0fd445f9670e10a";
    hash = "sha256-IFGWQ57kHWxqmeHwX0vg6NoTvTqwr4S5/lyvB9I5Fi4=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ];

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin {N64Recomp,RSPRecomp}
    install -Dm644 -t $out/share/licenses/${finalAttrs.pname} ../LICENSE

    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Tool to statically recompile N64 games into native executables";
    homepage = "https://github.com/N64Recomp/N64Recomp";
    license = with lib.licenses; [
      # N64Recomp
      mit

      # reverse engineering
      unfree
    ];
    maintainers = with lib.maintainers; [ qubitnano ];
    mainProgram = "N64Recomp";
    platforms = lib.platforms.linux;
    hydraPlatforms = [ ];
  };
})
