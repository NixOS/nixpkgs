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
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "SteamGridDB";
    repo = "SGDBoop";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/pXZMq80fb7Z+619ACnu/ZYWpouh59PIiruWY7l2cnQ=";
  };

  makeFlags = [
    # The flatpak install just copies things to /app - otherwise wants to do things with XDG
    "FLATPAK_ID=fake"
  ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail "/app/" "$out/"
  '';

  postInstall = ''
    rm -r "$out/share/metainfo"
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
