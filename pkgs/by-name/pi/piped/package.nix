{
  lib,
  buildNpmPackage,
  pnpm_9,
<<<<<<< HEAD
  fetchPnpmDeps,
  pnpmConfigHook,
  fetchFromGitHub,
  unstableGitUpdater,
}:
let
  pnpm = pnpm_9;
in
=======
  fetchFromGitHub,
  unstableGitUpdater,
}:

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
buildNpmPackage rec {
  pname = "piped";
  version = "0-unstable-2024-11-04";

  src = fetchFromGitHub {
    owner = "TeamPiped";
    repo = "piped";
    rev = "7866c06801baef16ce94d6f4dd0f8c1b8bc88153";
    hash = "sha256-o3TwE0s5rim+0VKR+oW9Rv3/eQRf2dgRQK4xjZ9pqCE=";
  };

<<<<<<< HEAD
  nativeBuildInputs = [ pnpm_9 ];
  npmConfigHook = pnpmConfigHook;
=======
  npmConfigHook = pnpm_9.configHook;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  installPhase = ''
    runHook preInstall
    cp dist $out -r
    runHook postInstall
  '';

  npmDeps = pnpmDeps;
<<<<<<< HEAD
  pnpmDeps = fetchPnpmDeps {
    inherit
      pname
      version
      src
      ;
    pnpm = pnpm_9;
=======
  pnpmDeps = pnpm_9.fetchDeps {
    inherit pname version src;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    fetcherVersion = 1;
    hash = "sha256-WtZfRZFRV9I1iBlAoV69GGFjdiQhTSBG/iiEadPVcys=";
  };

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    homepage = "https://github.com/TeamPiped/Piped";
    description = "Efficient and privacy-friendly YouTube frontend";
    maintainers = [ lib.maintainers.lucasew ];
    license = [ lib.licenses.agpl3Plus ];
  };

}
