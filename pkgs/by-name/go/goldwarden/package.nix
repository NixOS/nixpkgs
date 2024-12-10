{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchpatch,
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
  version = "0.2.13-unstable-2024-03-14";

  src = fetchFromGitHub {
    owner = "quexten";
    repo = "goldwarden";
    rev = "d6e1cd263365611e520a2ef6c7847c9da19362f1";
    hash = "sha256-IItKOmE0xHKO2u5jp7R20/T2eSvQ3QCxlzp6R4oiqf8=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/quexten/goldwarden/pull/140/commits/c134a0e61d51079c44865f68ab65cfb3aea6f8f2.patch";
      hash = "sha256-nClC/FYq3muXMeYXln+VVGUhanqElEgJRosWeSTNlmM=";
    })
    (fetchpatch {
      url = "https://github.com/quexten/goldwarden/pull/140/commits/86d4f907fba241fd66d0fb3c109c0281a9766bb4.patch";
      hash = "sha256-A8PBzfyd2blFIjCeO4xOVJMQjnEPwtK4wTcRcfsjyDk=";
    })
  ];

  postPatch = ''
    substituteInPlace browserbiometrics/chrome-com.8bit.bitwarden.json browserbiometrics/mozilla-com.8bit.bitwarden.json \
      --replace-fail "@PATH@" "$out/bin/goldwarden"

    substituteInPlace gui/com.quexten.Goldwarden.desktop \
      --replace-fail "Exec=goldwarden_ui_main.py" "Exec=$out/bin/goldwarden-gui"
    substituteInPlace gui/src/gui/browserbiometrics.py \
      --replace-fail "flatpak run --filesystem=home --command=goldwarden com.quexten.Goldwarden" "goldwarden"
    substituteInPlace gui/src/gui/ssh.py \
      --replace-fail "flatpak run --command=goldwarden com.quexten.Goldwarden" "goldwarden" \
      --replace-fail 'SSH_AUTH_SOCK=/home/$USER/.var/app/com.quexten.Goldwarden/data/ssh-auth-sock' 'SSH_AUTH_SOCK=/home/$USER/.goldwarden-ssh-agent.sock'
    substituteInPlace gui/src/{linux/main.py,linux/monitors/dbus_monitor.py,gui/settings.py} \
      --replace-fail "python3" "${(python3.buildEnv.override { extraLibs = pythonPath; }).interpreter}"
  '';

  vendorHash = "sha256-IH0p7t1qInA9rNYv6ekxDN/BT5Kguhh4cZfmL+iqwVU=";

  ldflags = [
    "-s"
    "-w"
  ];

  nativeBuildInputs = [
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
    chmod +x gui/goldwarden_ui_main.py
    ln -s $out/share/goldwarden/goldwarden_ui_main.py $out/bin/goldwarden-gui
    mkdir -p $out/share/goldwarden
    cp -r gui/* $out/share/goldwarden/
    rm $out/share/goldwarden/{com.quexten.Goldwarden.desktop,com.quexten.Goldwarden.metainfo.xml,goldwarden.svg,python3-requirements.json,requirements.txt}

    install -D gui/com.quexten.Goldwarden.desktop -t $out/share/applications
    install -D gui/goldwarden.svg -t $out/share/icons/hicolor/scalable/apps
    install -Dm644 gui/com.quexten.Goldwarden.metainfo.xml -t $out/share/metainfo
    install -Dm644 resources/com.quexten.goldwarden.policy -t $out/share/polkit-1/actions

    install -D browserbiometrics/chrome-com.8bit.bitwarden.json $out/etc/chrome/native-messaging-hosts/com.8bit.bitwarden.json
    install -D browserbiometrics/chrome-com.8bit.bitwarden.json $out/etc/chromium/native-messaging-hosts/com.8bit.bitwarden.json
    install -D browserbiometrics/chrome-com.8bit.bitwarden.json $out/etc/edge/native-messaging-hosts/com.8bit.bitwarden.json
    install -D browserbiometrics/mozilla-com.8bit.bitwarden.json $out/lib/mozilla/native-messaging-hosts/com.8bit.bitwarden.json
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
    maintainers = with maintainers; [ arthsmn ];
    mainProgram = "goldwarden";
    platforms = platforms.linux; # Support for other platforms is not yet ready, see https://github.com/quexten/goldwarden/issues/4
  };
}
