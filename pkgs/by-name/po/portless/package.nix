{
  lib,
  stdenv,
  fetchFromGitHub,
  nodejs_24,
  pnpm_11,
  fetchPnpmDeps,
  pnpmConfigHook,
  makeWrapper,
  openssl,
  nix-update-script,
}:

let
  pnpm = pnpm_11;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "portless";
  version = "0.15.5";

  src = fetchFromGitHub {
    owner = "vercel-labs";
    repo = "portless";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TE685ONcQs5LmyR3+4iq1lMTvCxa+m8+WxSparmeA10=";
  };

  pnpmWorkspaces = [ "portless..." ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      pnpmWorkspaces
      ;
    inherit pnpm;
    fetcherVersion = 4;
    hash = "sha256-8IiT21zxV1bk+EE2/33IAQDls30japACTHChEDT1UVY=";
  };

  nativeBuildInputs = [
    makeWrapper
    nodejs_24
    pnpm
    pnpmConfigHook
  ];

  strictDeps = true;

  buildPhase = ''
    runHook preBuild

    pnpm --filter portless build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/lib/portless" "$out/bin"
    cp -r packages/portless/{dist,package.json} "$out/lib/portless/"
    makeWrapper "${lib.getExe nodejs_24}" "$out/bin/portless" \
      --add-flags "$out/lib/portless/dist/cli.js" \
      --prefix PATH : ${openssl}/bin

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Replace port numbers with stable, named .localhost URLs for local development";
    homepage = "https://portless.sh";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      GuillaumeDesforges
      thenonameguy
    ];
    platforms = lib.platforms.linux;
    mainProgram = "portless";
  };
})
