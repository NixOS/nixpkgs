{
  lib,
  fetchFromGitHub,
  gobject-introspection,
  gtk-layer-shell,
  gtk3,
  python3Packages,
  wrapGAppsHook3,
}:

python3Packages.buildPythonApplication rec {
  pname = "nwg-hello";
  version = "0.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nwg-piotr";
    repo = "nwg-hello";
    tag = "v${version}";
    hash = "sha256-h/2e2pQw4ID17kT36AMzFe/FX6pYxxOxqkmHVHS5R1E=";
  };

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    gtk-layer-shell
  ];

  build-system = [ python3Packages.setuptools ];

  dependencies = [
    python3Packages.pygobject3
  ];

  postPatch = ''
    # hard coded paths
    substituteInPlace nwg_hello/main.py \
      --replace-fail '/etc/nwg-hello' "$out/etc/nwg-hello" \
      --replace-fail "/usr/share/xsessions" "/run/current-system/sw/share/xsessions" \
      --replace-fail "/usr/share/wayland-sessions" "/run/current-system/sw/share/wayland-sessions"

    substituteInPlace nwg-hello-default.json \
      --replace-fail "/usr/share/xsessions" "/run/current-system/sw/share/xsessions" \
      --replace-fail "/usr/share/wayland-sessions" "/run/current-system/sw/share/wayland-sessions"

    substituteInPlace nwg_hello/ui.py --replace-fail '/usr/share/nwg-hello' "$out/share/nwg-hello"
  '';

  postInstall = ''
    install -D -m 644 -t "$out/etc/nwg-hello/" nwg-hello-default.json nwg-hello-default.css hyprland.conf sway-config README
    install -D -m 644 -t "$out/share/nwg-hello/" nwg.jpg
    install -D -m 644 -t "$out/share/nwg-hello/" img/*
  '';

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  # Upstream has no tests
  doCheck = false;
  pythonImportsCheck = [ "nwg_hello" ];

  meta = {
    homepage = "https://github.com/nwg-piotr/nwg-hello";
    changelog = "https://github.com/nwg-piotr/nwg-hello/releases/tag/${src.tag}";
    description = "GTK3-based greeter for the greetd daemon, written in python";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = [ ];
    mainProgram = "nwg-hello";
  };
}
