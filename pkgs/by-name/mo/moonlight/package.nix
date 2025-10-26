{
  lib,
  stdenv,
  pnpm_10,
  nodejs_22,
  fetchFromGitHub,
  nix-update-script,
  discord,
  discord-ptb,
  discord-canary,
  discord-development,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "moonlight";
  version = "1.3.32";

  src = fetchFromGitHub {
    owner = "moonlight-mod";
    repo = "moonlight";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aXap/wUjjJTCy2eq7p7BL6ZYOVZEBVY4/YkrDtbIj2Q=";
  };

  nativeBuildInputs = [
    nodejs_22
    pnpm_10.configHook
  ];

  pnpmDeps = pnpm_10.fetchDeps {
    inherit (finalAttrs) pname version src;

    buildInputs = [ nodejs_22 ];

    fetcherVersion = 2;
    hash = "sha256-gv+PHGbo0IiPgcxi0RAvsNmGLHWZar3SB4eW7NbJRJY=";
  };

  env = {
    NODE_ENV = "production";
    MOONLIGHT_BRANCH = "stable";
    MOONLIGHT_VERSION = "v${finalAttrs.version} (nixpkgs)";
  };

  patches = [
    ./disable_updates.patch
  ];

  buildPhase = ''
    runHook preBuild

    pnpm run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    cp -r dist $out

    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests = lib.genAttrs' [ discord discord-ptb discord-canary discord-development ] (
      p: lib.nameValuePair p.pname p.tests.withMoonlight
    );
  };

  meta = with lib; {
    description = "Discord client modification, focused on enhancing user and developer experience";
    longDescription = ''
      Moonlight is a ***passion project***—yet another Discord client mod—focused on providing a decent user
      and developer experience. Heavily inspired by hh3 (a private client mod) and the projects before it, namely EndPwn.
      All core code is original or used with permission from their respective authors where not copyleft.
    '';
    homepage = "https://moonlight-mod.github.io";
    downloadPage = "https://moonlight-mod.github.io/using/install/#nix";
    changelog = "https://raw.githubusercontent.com/moonlight-mod/moonlight/refs/tags/v${finalAttrs.version}/CHANGELOG.md";

    license = licenses.lgpl3;
    maintainers = with maintainers; [
      ilys
      FlameFlag
    ];
  };
})
