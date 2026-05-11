{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  gtk3,
  curl,
  libepoxy,
  meson,
  ninja,
  wrapGAppsHook3,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "orbvis";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "wojciech-graj";
    repo = "orbvis";
    tag = "v${finalAttrs.version}";
    hash = "sha256-U19kslgAULBBFozK5KUtew6KRsFeJ4+h8bL9cXmnzso=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    curl
    libepoxy
  ];

  postInstall = ''
    install -Dm444 $src/flatpak/io.github.wojciech_graj.OrbVis.desktop -t $out/share/applications
    install -Dm444 $src/flatpak/128x128/io.github.wojciech_graj.OrbVis.png -t $out/share/icons/hicolor/128x128/apps
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "View and propagate the full CelesTrak satellite catalog in realtime";
    homepage = "https://github.com/wojciech-graj/OrbVis";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ thtrf ];
    mainProgram = "orbvis";
    platforms = lib.platforms.linux;
  };
})
