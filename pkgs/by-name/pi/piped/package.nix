{
  lib,
  stdenv,
  fetchFromGitHub,
  nodejs,
  pnpm_10,
  pnpmConfigHook,
  fetchPnpmDeps,
  unstableGitUpdater,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "piped";
  version = "0-unstable-2026-06-16";

  src = fetchFromGitHub {
    owner = "TeamPiped";
    repo = "piped";
    rev = "0cd9b2f6523fa5af7be0daec2802cc0b78c16747";
    hash = "sha256-IC2nTB4iue+hQ00WOKh/BC7LXsIhdTKYPmn3RYpZk7c=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm_10
    pnpmConfigHook
  ];

  buildPhase = ''
    runHook preBuild

    pnpm build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    cp -r dist "$out"

    runHook postInstall
  '';

  strictDeps = true;
  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      ;
    pnpm = pnpm_10;
    fetcherVersion = 4;
    hash = "sha256-55nG7tfXtxnyfZop+8Wg8rSFOHQi0TjRc0QT16erX1E=";
  };

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    homepage = "https://github.com/TeamPiped/Piped";
    description = "Efficient and privacy-friendly YouTube frontend";
    maintainers = [ lib.maintainers.SchweGELBin ];
    license = [ lib.licenses.agpl3Plus ];
  };

})
