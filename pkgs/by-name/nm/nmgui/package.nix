{
  lib,
  python3Packages,
  fetchFromGitHub,
  wrapGAppsHook4,
  gobject-introspection,
  gtk4,
  glib,
  makeDesktopItem,
  copyDesktopItems,
  networkmanager,
}:

python3Packages.buildPythonApplication rec {
  pname = "nmgui";
  version = "1.0.0";
  format = "other";

  src = fetchFromGitHub {
    owner = "s-adi-dev";
    repo = "nmgui";
    tag = "v${version}";
    hash = "sha256-HS/n40Ng8S5N14DtEH/upwlxdzwCoOEJA40EMdCcLw4=io";
  };

  nativeBuildInputs = [
    wrapGAppsHook4
    gobject-introspection
    copyDesktopItems
  ];

  buildInputs = [
    gtk4
    glib
  ];

  dependencies = with python3Packages; [
    pygobject3
    nmcli
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "nmgui";
      exec = "nmgui";
      icon = "network-wireless-symbolic";
      comment = "GTK4-based Network Manager GUI using nmcli";
      desktopName = "NM GUI";
      categories = [
        "Network"
        "GTK"
      ];
      startupNotify = true;
    })
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{bin,share/applications,opt/nmgui}
    # Copy the app files
    cp -r app $out/opt/nmgui/

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper ${python3Packages.python.interpreter} $out/bin/nmgui \
      --add-flags "$out/opt/nmgui/app/main.py" \
      --prefix PYTHONPATH : "$PYTHONPATH" \
      "''${gappsWrapperArgs[@]}"
  '';

  meta = {
    description = "Python library for interacting with NetworkManager CLI";
    homepage = "https://github.com/s-adi-dev/nmgui";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ktechmidas ];
    mainProgram = "nmgui";
    inherit (networkmanager.meta) platforms;
    changelog = "https://github.com/s-adi-dev/nmgui/releases/tag/v${version}";
  };
}
