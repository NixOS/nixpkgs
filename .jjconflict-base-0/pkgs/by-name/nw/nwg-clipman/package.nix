{
  lib,
  fetchFromGitHub,
  python3Packages,
  gobject-introspection,
  wrapGAppsHook3,
  gtk-layer-shell,
  gtk3,
  wl-clipboard,
  cliphist,
  nix-update-script,
}:

python3Packages.buildPythonPackage rec {
  pname = "nwg-clipman";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "nwg-piotr";
    repo = "nwg-clipman";
    rev = "refs/tags/v${version}";
    hash = "sha256-bAE9E6P+qfKrfRxb134k4r7DtIWGB+4JdiXKpI7gJ5M=";
  };

  build-system = [ python3Packages.setuptools ];

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook3
  ];

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  buildInputs = [
    gtk-layer-shell
    gtk3
  ];

  dependencies = with python3Packages; [ pygobject3 ];

  nativeCheckInputs = [
    wl-clipboard
    cliphist
  ];

  postInstall = ''
    install -Dm644 nwg-clipman.desktop -t $out/share/applications/
    install -Dm644 nwg-clipman.svg -t $out/share/pixmaps/
  '';

  strictDeps = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "GTK3-based GUI for cliphist";
    homepage = "https://github.com/nwg-piotr/nwg-clipman";
    changelog = "https://github.com/nwg-piotr/nwg-clipman/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ averyanalex ];
    platforms = lib.platforms.linux;
    mainProgram = "nwg-clipman";
  };
}
