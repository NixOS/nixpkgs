{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  fetchPnpmDeps,
  nix-update-script,
  nodejs,
  pnpmConfigHook,
  pnpm_9,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "shelter";
  version = "0-unstable-2026-02-11";
  src = fetchFromGitHub {
    owner = "uwu";
    repo = "shelter";
    rev = "8d4ca369bf01abf348df9d4e111d534800c7a38c";
    hash = "sha256-X6BsCImOa8NvOnyYZf0lHVvrgqk6RgKpz9JZjb28HBw=";
  };

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm_9
  ];

  pnpmWorkspaces = [
    "shelter"
    "@uwu/shelter-ui"
    "@uwu/shelter-storage"
  ];
  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      pnpmWorkspaces
      ;
    hash = "sha256-FOdBmJZfLo6/3aV/F/7g6emnX8dyoRbOtdzYO4KU/Ow=";
    pnpm = pnpm_9;
    fetcherVersion = 3;
  };

  buildPhase = ''
    runHook preBuild

    pnpm --filter=@uwu/shelter-ui prepare
    pnpm --filter=shelter build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    cp -r packages/shelter/dist $out

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version=branch"
      "--version-regex=(0.*)"
    ];
  };

  meta = {
    description = "New generation Discord client mod built to be essentially bulletproof";
    homepage = "https://shelter.uwu.network/";
    license = lib.licenses.cc0;
    maintainers = with lib.maintainers; [ bandithedoge ];
  };
})
