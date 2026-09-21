{
  fetchFromGitHub,
  nix-update-script,
  lib,
  nodejs,
  pnpm_11,
  fetchPnpmDeps,
  pnpmConfigHook,
  stdenvNoCC,
  pnpmBuildHook,
  makeWrapper,
}:
let
  pnpm = pnpm_11;
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "elk";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "elk-zone";
    repo = "elk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QKylYdJ23QRIqvHtWObJLl05nkSpku+HravvAoAqs7I=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  postPatch = ''
    substituteInPlace pnpm-workspace.yaml --replace-fail \
      "verifyDepsBeforeRun: install" \
      "verifyDepsBeforeRun: false"
  '';

  nativeBuildInputs = [
    nodejs
    pnpmBuildHook
    pnpmConfigHook
    pnpm
    makeWrapper
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      ;
    fetcherVersion = 4;
    hash = "sha256-JgIq9YSOcMJbkxMyzH+HcpaBgEtkxp5utwENn5rmJ90=";
  };

  env.NUXT_TELEMETRY_DISABLED = "1";

  preBuild = ''
    pnpm run prepare
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/elk
    cp -r .output/* $out/share/elk/

    mkdir -p $out/bin
    makeWrapper ${lib.getExe nodejs} $out/bin/elk \
      --add-flags "$out/share/elk/server/index.mjs"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A nimble Mastodon web client";
    homepage = "https://github.com/elk-zone/elk";
    changelog = "https://github.com/elk-zone/elk/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.onny ];
    mainProgram = "elk";
    platforms = lib.platforms.linux;
  };
})
