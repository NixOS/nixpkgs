{
  lib,
  stdenv,
  fetchFromGitHub,
  nodejs,
  pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,
  makeWrapper,
  versionCheckHook,
  nix-update-script,
}:

let
  pnpm = pnpm_10;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "pake";
  version = "3.17.2";

  src = fetchFromGitHub {
    owner = "tw93";
    repo = "Pake";
    tag = "V${finalAttrs.version}";
    hash = "sha256-UbsbrkNHczzwg6B9NkhRi9cofa7IqHnq7zg4bYPqAz4=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 3;
    hash = "sha256-GrX0TXUDzcmyIlQexq90eJiQ+C62kGdC815dJ0AibN4=";
  };

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm
    makeWrapper
  ];

  strictDeps = true;
  __structuredAttrs = true;

  buildPhase = ''
    runHook preBuild

    pnpm run cli:build

    # Prune devDependencies to keep runtime closure clean
    CI=true pnpm prune --prod

    # Clean up broken symlinks if left behind by pnpm prune
    find node_modules -xtype l -delete

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/pake $out/bin
    cp -r dist node_modules package.json src-tauri $out/lib/pake/

    makeWrapper ${nodejs}/bin/node $out/bin/pake \
      --add-flags "$out/lib/pake/dist/cli.js" \
      --prefix PATH : ${
        lib.makeBinPath [
          nodejs
          pnpm
        ]
      }

    runHook postInstall
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Turn any webpage into a desktop app with Rust and Tauri";
    homepage = "https://github.com/tw93/Pake";
    changelog = "https://github.com/tw93/Pake/releases/tag/V${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ rebizzz ];
    mainProgram = "pake";
    platforms = lib.platforms.unix;
  };
})
