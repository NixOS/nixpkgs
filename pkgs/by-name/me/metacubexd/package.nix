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
  version = "1.176.1";

  src = fetchFromGitHub {
    owner = "MetaCubeX";
    repo = "metacubexd";
    rev = "v${finalAttrs.version}";
    hash = "sha256-96mWjODfgIoJM/c/2c+KdPDxWCEGszglkRqjabW8auk=";
  };

  nativeBuildInputs = [
    pnpm_9.configHook
    nodejs
  ];

  pnpmDeps = pnpm_9.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-xDcqGvM8J6miDwiwNQODnPVq63flitva6/nPLYa9cgY=";
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
