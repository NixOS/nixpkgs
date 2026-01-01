{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  zip,
  unzip,
  makeWrapper,
  installShellFiles,
  unstableGitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "n64recomp";
<<<<<<< HEAD
  version = "0-unstable-2025-12-11";
=======
  version = "0-unstable-2025-11-24";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "N64Recomp";
    repo = "N64Recomp";
<<<<<<< HEAD
    rev = "98bf104b1b5ed83126af8bcab0cc964782617dbf";
    hash = "sha256-qDV52g04tOCQW+Nqzm8pnXwqs4q027TnHyuGYsGzIhU=";
=======
    rev = "f14ffe6064881e29e4e7da016be525f6c04f4369";
    hash = "sha256-6WAG7kVeI7NqqSu9Ll2Mxw5F9IpjFz+xSRRi/32gQRk=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    fetchSubmodules = true;
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    makeWrapper
    installShellFiles
  ];

  installPhase = ''
    runHook preInstall

    installBin {N64Recomp,RSPRecomp,RecompModTool}
    install -Dm644 -t $out/share/licenses/n64recomp ../LICENSE

    wrapProgram $out/bin/RecompModTool \
      --prefix PATH : ${zip}/bin \
      --prefix PATH : ${unzip}/bin

    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };

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
  };
})
