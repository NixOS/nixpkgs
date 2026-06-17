{
  lib,
  buildNpmPackage,
  pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,
  fetchFromGitHub,
  unstableGitUpdater,
}:
let
  pnpm = pnpm_10;
in
buildNpmPackage rec {
  pname = "piped";
  version = "0-unstable-2026-06-16";

  src = fetchFromGitHub {
    owner = "TeamPiped";
    repo = "piped";
    rev = "0cd9b2f6523fa5af7be0daec2802cc0b78c16747";
    hash = "sha256-IC2nTB4iue+hQ00WOKh/BC7LXsIhdTKYPmn3RYpZk7c=";
  };

  nativeBuildInputs = [ pnpm ];
  npmConfigHook = pnpmConfigHook;

  installPhase = ''
    runHook preInstall
    cp dist $out -r
    runHook postInstall
  '';

  npmDeps = pnpmDeps;
  pnpmDeps = fetchPnpmDeps {
    inherit
      pname
      version
      src
      pnpm
      ;
    fetcherVersion = 4;
    hash = "sha256-55nG7tfXtxnyfZop+8Wg8rSFOHQi0TjRc0QT16erX1E=";
  };

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    homepage = "https://github.com/TeamPiped/Piped";
    description = "Efficient and privacy-friendly YouTube frontend";
    maintainers = [ ];
    license = [ lib.licenses.agpl3Plus ];
  };

}
