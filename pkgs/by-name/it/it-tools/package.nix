{
  stdenv,
  lib,
  fetchFromGitHub,
  nodejs,
  pnpm,
}:
stdenv.mkDerivation rec {
  pname = "it-tools";
  version = "2024.5.13-a0bc346";

  src = fetchFromGitHub {
    owner = "CorentinTh";
    repo = "it-tools";
    rev = "v${version}";
    hash = "sha256-hU+iPefnEt9MCipETAzaeguxi7aU9iyjwJdeddILJzU=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm.configHook
  ];

  pnpmDeps = pnpm.fetchDeps {
    inherit pname version src;
    hash = "sha256-kui9RcKWaHbQmeVtOV6m9+f7xf6OjjnMSOCKADOTy40=";
  };

  buildPhase = ''
    runHook preBuild

    pnpm build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    cp -R ./dist/* $out/lib/

    runHook postInstall
  '';

  meta = {
    description = "Collection of handy online tools for developers, with great UX.";
    homepage = "https://it-tools.tech/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ akotro ];
  };
}
