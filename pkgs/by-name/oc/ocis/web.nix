{
  lib,
  stdenvNoCC,
  nodejs,
  pnpm,
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
    pnpm.configHook
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

  pnpmDeps = pnpm.fetchDeps {
    inherit pname version src;
    hash = "sha256-3Erva6srdkX1YQ727trx34Ufx524nz19MUyaDQToz6M=";
  };

  meta = {
    homepage = "https://github.com/owncloud/ocis";
    description = "ownCloud Infinite Scale Stack";
    maintainers = with lib.maintainers; [ xinyangli ];
    license = lib.licenses.agpl3Only;
  };
}
