{
  lib,
  stdenv,
  fetchFromGitHub,
  nodejs,
  pnpm_9,
  fetchPnpmDeps,
  pnpmConfigHook,
  makeWrapper,
  electron,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "aonsoku";
  version = "0.10.2";

  src = fetchFromGitHub {
    owner = "victoralvesf";
    repo = "aonsoku";
    tag = "v${version}";
    hash = "sha256-/6mFMZu15daIrB1yw4xN0KXFl3ZYsLNKxAk3Bkc5jlg=";
  };

  patches = [
    ./remove_updater.patch
  ];

  # Use fetchPnpmDeps with lockfile
  pnpmDeps = fetchPnpmDeps {
    inherit pname version src;
    pnpm = pnpm_9;
    fetcherVersion = 1;
    hash = "sha256-htDXrs9ayaWBNOL9tHfWndHOhr98iDKBy7mmFLle6Lo=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm_9
    pnpmConfigHook
    makeWrapper
    electron
  ];

  buildInputs = [ pnpmDeps ];

  preConfigure = ''
    export ELECTRON_SKIP_BINARY_DOWNLOAD=1
  '';

  buildPhase = ''
    runHook preBuild
    pnpm run electron:build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/aonsoku/out

    # Electron build output
    cp -r out/* $out/lib/aonsoku/out/

    # Runtime assets
    mkdir -p $out/lib/aonsoku/out/main/resources
    cp -r resources/* $out/lib/aonsoku/out/main/resources/

    # JS runtime deps
    cp -r node_modules $out/lib/aonsoku/

    mkdir -p $out/bin
    makeWrapper ${electron}/bin/electron $out/bin/Aonsoku \
      --add-flags $out/lib/aonsoku/out/main/index.js \
      --set ELECTRON_IS_DEV 0

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };
  meta = {
    description = "Modern desktop client for Navidrome/Subsonic servers";
    homepage = "https://github.com/victoralvesf/aonsoku";
    changelog = "https://github.com/victoralvesf/aonsoku/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      genga898
    ];
    mainProgram = "Aonsoku";
  };
}
