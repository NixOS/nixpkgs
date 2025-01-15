{
  lib,
  fetchFromGitHub,
  nix-update-script,
  nodejs,
  pnpm_9,
  stdenv,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "metacubexd";
  version = "1.168.0";

  src = fetchFromGitHub {
    owner = "MetaCubeX";
    repo = "metacubexd";
    rev = "v${finalAttrs.version}";
    hash = "sha256-HTHqf4R3eD+LlI9qmSz4id0SPVgid8Qp4P9JZzXGKlk=";
  };

  nativeBuildInputs = [
    pnpm_9.configHook
    nodejs
  ];

  pnpmDeps = pnpm_9.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-OFcXsAFMwY6BnyEVK9Px1g17CHCQWyPpr1My7u3XPpU=";
  };

  buildPhase = ''
    runHook preBuild

    pnpm build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    cp -r ./dist $out

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Clash.Meta Dashboard, The Official One, XD";
    homepage = "https://github.com/MetaCubeX/metacubexd";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ Guanran928 ];
  };
})
