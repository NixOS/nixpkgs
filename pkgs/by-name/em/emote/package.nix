{
  lib,
  fetchFromGitHub,
  gobject-introspection,
  gtk4,
  libadwaita,
  meson,
  ninja,
  pkg-config,
  python3Packages,
  wl-clipboard,
  wrapGAppsHook4,
  xdotool,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "emote";
  version = "5.2.1";
  pyproject = false; # Built with meson

  src = fetchFromGitHub {
    owner = "tom-james-watson";
    repo = "Emote";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1ySZEiZbT9u9YRn+rZS39dWecvbLmMZS2r8aAnIMyI8=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    gobject-introspection
  ];

  buildInputs = [
    # used by gobject-introspection's setup-hook and only detected at runtime
    libadwaita
    gtk4
  ];

  dependencies = with python3Packages; [
    pygobject3.out # don't propagate dev output
    setproctitle
  ];

  dontWrapGApps = true;
  preFixup = ''
    makeWrapperArgs+=(
      "''${gappsWrapperArgs[@]}"
      --prefix PATH : ${
        lib.makeBinPath [
          xdotool
          wl-clipboard
        ]
      }
    )
  '';

  meta = {
    description = "Modern emoji picker for Linux";
    mainProgram = "emote";
    homepage = "https://github.com/tom-james-watson/emote";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      SuperSandro2000
      aleksana
    ];
    platforms = lib.platforms.linux;
  };
})
