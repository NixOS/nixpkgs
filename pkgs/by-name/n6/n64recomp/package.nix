{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  installShellFiles,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "n64recomp";
  version = "0-unstable-2025-02-27";

  src = fetchFromGitHub {
    owner = "N64Recomp";
    repo = "N64Recomp";
    tag = "mod-tool-release";
    hash = "sha256-DlzqixK8qnKrwN5zAqaae2MoXLqIIIzIkReVSk2dDFg=";
    fetchSubmodules = true;
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    installShellFiles
  ];

  installPhase = ''
    runHook preInstall

    installBin {N64Recomp,RSPRecomp,RecompModTool}
    install -Dm644 -t $out/share/licenses/n64recomp ../LICENSE

    runHook postInstall
  '';

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
