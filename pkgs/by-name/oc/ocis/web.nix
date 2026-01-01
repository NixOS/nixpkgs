{
  lib,
  stdenvNoCC,
  nodejs,
  pnpm_9,
<<<<<<< HEAD
  fetchPnpmDeps,
  pnpmConfigHook,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation rec {
  pname = "ocis-web";
  version = "8.0.5";

  src = fetchFromGitHub {
    owner = "owncloud";
    repo = "web";
    rev = "refs/tags/v${version}";
    hash = "sha256-hupdtK/V74+X7/eXoDmUjFvSKuhnoOtNQz7o6TLJXG4=";
  };

  nativeBuildInputs = [
    nodejs
<<<<<<< HEAD
    pnpmConfigHook
    pnpm_9
=======
    pnpm_9.configHook
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  buildPhase = ''
    runHook preBuild
    pnpm build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share
    cp -r dist/* $out/share/
    runHook postInstall
  '';

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
    hash = "sha256-3Erva6srdkX1YQ727trx34Ufx524nz19MUyaDQToz6M=";
  };

  meta = {
    homepage = "https://github.com/owncloud/ocis";
    description = "ownCloud Infinite Scale Stack";
    maintainers = with lib.maintainers; [ xinyangli ];
    license = lib.licenses.agpl3Only;
  };
}
