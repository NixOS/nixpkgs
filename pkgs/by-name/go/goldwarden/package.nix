{ lib
, bash
, buildGoModule
, fetchFromGitHub
, gobject-introspection
, gtk4
, libadwaita
, libfido2
, libnotify
, python3
, wrapGAppsHook
}:

buildGoModule rec {
  pname = "goldwarden";
  version = "0.2.13";

  src = fetchFromGitHub {
    owner = "quexten";
    repo = "goldwarden";
    rev = "v${version}";
    hash = "sha256-4KxPtsIEW46p+cFx6yeSdNlsffy9U31k+ZSkE6V0AFc=";
  };

  postPatch = ''
    substituteInPlace browserbiometrics/manifests.go \
      --replace-fail "/bin/bash" "${lib.getExe bash}"
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

  ldflags = [ "-s" "-w" ];

  nativeBuildInputs = [
    gobject-introspection
    python3.pkgs.wrapPython
    wrapGAppsHook
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
