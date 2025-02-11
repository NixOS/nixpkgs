{
  lib,
  blueprint-compiler,
  buildGoModule,
  fetchFromGitHub,
  gobject-introspection,
  gtk4,
  libadwaita,
  libfido2,
  libnotify,
  python3,
  wrapGAppsHook4,
}:

buildGoModule rec {
  pname = "goldwarden";
  version = "0.3.6";

  src = fetchFromGitHub {
    owner = "quexten";
    repo = "goldwarden";
    rev = "v${version}";
    hash = "sha256-wAQFx0DKLLKztETAz1eM+eBFiAkSCgd8qqRtLV1Kz9g=";
  };

  postPatch = ''
    substituteInPlace gui/src/{linux/main.py,linux/monitors/dbus_monitor.py,gui/settings.py} \
      --replace-fail "python3" "${(python3.buildEnv.override { extraLibs = pythonPath; }).interpreter}"

    substituteInPlace gui/com.quexten.Goldwarden.desktop \
      --replace-fail "Exec=goldwarden_ui_main.py" "Exec=$out/bin/goldwarden-gui"

    substituteInPlace gui/src/gui/resources/commands.json \
      --replace-fail "flatpak run --filesystem=home --command=goldwarden com.quexten.Goldwarden" "goldwarden" \
      --replace-fail "flatpak run --command=goldwarden com.quexten.Goldwarden" "goldwarden" \
      --replace-fail 'SSH_AUTH_SOCK=/home/$USER/.var/app/com.quexten.Goldwarden/data/ssh-auth-sock' 'SSH_AUTH_SOCK=/home/$USER/.goldwarden-ssh-agent.sock'

    substituteInPlace cli/browserbiometrics/chrome-com.8bit.bitwarden.json cli/browserbiometrics/mozilla-com.8bit.bitwarden.json \
      --replace-fail "@PATH@" "$out/bin/goldwarden"
  '';

  vendorHash = "sha256-zWACjW/WZC0ZLmRV1VwcRROG218PCZ6aCPOreCG/5sE=";

  ldflags = [
    "-s"
    "-w"
  ];

  nativeBuildInputs = [
    blueprint-compiler
    gobject-introspection
    python3.pkgs.wrapPython
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    libadwaita
    libfido2
    libnotify
  ];

  pythonPath = with python3.pkgs; [
    dbus-python
    pygobject3
    tendo
  ];

  postInstall = ''
    blueprint-compiler batch-compile gui/src/gui/.templates/ gui/src/gui/ gui/src/gui/*.blp
    chmod +x gui/goldwarden_ui_main.py

    mkdir -p $out/share/goldwarden
    cp -r gui/* $out/share/goldwarden/
    ln -s $out/share/goldwarden/goldwarden_ui_main.py $out/bin/goldwarden-gui
    rm $out/share/goldwarden/{com.quexten.Goldwarden.desktop,com.quexten.Goldwarden.metainfo.xml,com.quexten.Goldwarden.svg,python3-requirements.json,requirements.txt}

    install -D gui/com.quexten.Goldwarden.desktop -t $out/share/applications
    install -D gui/com.quexten.Goldwarden.svg -t $out/share/icons/hicolor/scalable/apps
    install -Dm644 gui/com.quexten.Goldwarden.metainfo.xml -t $out/share/metainfo
    install -Dm644 cli/resources/com.quexten.goldwarden.policy -t $out/share/polkit-1/actions

    install -D cli/browserbiometrics/chrome-com.8bit.bitwarden.json $out/etc/chrome/native-messaging-hosts/com.8bit.bitwarden.json
    install -D cli/browserbiometrics/chrome-com.8bit.bitwarden.json $out/etc/chromium/native-messaging-hosts/com.8bit.bitwarden.json
    install -D cli/browserbiometrics/chrome-com.8bit.bitwarden.json $out/etc/edge/native-messaging-hosts/com.8bit.bitwarden.json
    install -D cli/browserbiometrics/mozilla-com.8bit.bitwarden.json $out/lib/mozilla/native-messaging-hosts/com.8bit.bitwarden.json
  '';

  dontWrapGApps = true;
  postFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
    wrapPythonProgramsIn $out/share/goldwarden "$out/share/goldwarden $pythonPath"
  '';

  meta = with lib; {
    description = "Feature-packed Bitwarden compatible desktop integration";
    homepage = "https://github.com/quexten/goldwarden";
    license = licenses.mit;
    maintainers = with maintainers; [
      arthsmn
      justanotherariel
    ];
    mainProgram = "goldwarden";
    platforms = platforms.linux; # Support for other platforms is not yet ready, see https://github.com/quexten/goldwarden/issues/4
  };
}
