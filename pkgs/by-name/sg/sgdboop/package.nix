{
  lib,
  stdenv,
  fetchFromGitHub,
  curl,
  pkg-config,
  wrapGAppsHook3,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "sgdboop";
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "SteamGridDB";
    repo = "SGDBoop";
    tag = "v${finalAttrs.version}";
    hash = "sha256-l4l5CWupL/V/qlnFZIgqUBagc5qg0DDv/zz2yc0mtng=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm755 SGDBoop \
      $out/bin/SGDBoop

    install -Dm644 res/linux/com.steamgriddb.SGDBoop.desktop \
      $out/share/applications/com.steamgriddb.SGDBoop.desktop

    install -Dm444 res/com.steamgriddb.SGDBoop.svg \
      $out/share/icons/hicolor/scalable/apps/com.steamgriddb.SGDBoop.svg

    runHook postInstall
  '';

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    curl
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Applying custom artwork to Steam, using SteamGridDB";
    homepage = "https://github.com/SteamGridDB/SGDBoop/";
    license = lib.licenses.zlib;
    maintainers = with lib.maintainers; [
      saturn745
      fazzi
    ];
    mainProgram = "SGDBoop";
    platforms = lib.platforms.linux;
  };
})
