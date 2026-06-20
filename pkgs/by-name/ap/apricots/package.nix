{
  lib,
  stdenv,
  fetchFromGitea,
  autoreconfHook,
  pkg-config,
  SDL2,
  openal,
  alure,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "apricots";
  version = "0.2.9";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "moggers87";
    repo = "apricots";
    rev = "v${finalAttrs.version}";
    hash = "sha256-nIa0a1HO8sShabDWCuDgg+VvcRJbZlaZRsuJB3Dsjfc=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    SDL2.dev
  ];

  buildInputs = [
    SDL2
    openal
    alure
  ];

  autoreconfFlags = [
    "-vfi"
    "--warnings=none"
  ];

  postInstall = ''
    install -Dm644 contrib/apricots.desktop -t "$out/share/applications/"
    install -Dm644 contrib/desktop-icon.png "$out/share/icons/hicolor/24x24/apps/apricots.png"
    install -Dm644 AUTHORS ChangeLog NEWS README.md -t "$out/share/doc/apricots/"
    install -Dm644 COPYING -t "$out/share/licenses/apricots/"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "2D plane shooter game";
    homepage = "https://codeberg.org/moggers87/apricots";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ Zaczero ];
    mainProgram = "apricots";
    platforms = lib.platforms.unix;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
})
