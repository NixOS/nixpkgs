{ lib
, fetchFromGitHub
, gobject-introspection
, gtk-layer-shell
, gtk3
, python3Packages
, wrapGAppsHook3
}:

python3Packages.buildPythonApplication rec {
  pname = "nwg-hello";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "nwg-piotr";
    repo = "nwg-hello";
    rev = "refs/tags/v${version}";
    hash = "sha256-WKDj68hQDPNsqyDG9kB1SklRIl/BSfVl7ebjVKA+33c=";
  };

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    gtk-layer-shell
  ];

  propagatedBuildInputs = [
    python3Packages.pygobject3
  ];

  postPatch = ''
    # hard coded paths
    substituteInPlace nwg_hello/main.py \
      --replace '/etc/nwg-hello' "$out/etc/nwg-hello" \
      --replace "/usr/share/xsessions" "/run/current-system/sw/share/xsessions" \
      --replace "/usr/share/wayland-sessions" "/run/current-system/sw/share/wayland-sessions"

    substituteInPlace nwg-hello-default.json \
      --replace "/usr/share/xsessions" "/run/current-system/sw/share/xsessions" \
      --replace "/usr/share/wayland-sessions" "/run/current-system/sw/share/wayland-sessions"

    substituteInPlace nwg_hello/ui.py --replace '/usr/share/nwg-hello' "$out/share/nwg-hello"
  '';

  postInstall = ''
    install -D -m 644 -t "$out/etc/nwg-hello/" nwg-hello-default.json nwg-hello-default.css hyprland.conf sway-config README
    install -D -m 644 -t "$out/share/nwg-hello/" nwg.jpg
    install -D -m 644 -t "$out/share/nwg-hello/" img/*
  '';

  # Upstream has no tests
  doCheck = false;
  pythonImportsCheck = [ "nwg_hello" ];

  meta = {
    homepage = "https://github.com/nwg-piotr/nwg-hello";
    description = "GTK3-based greeter for the greetd daemon, written in python";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = [ ];
    mainProgram = "nwg-hello";
  };
}
