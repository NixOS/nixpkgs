{
  lib,
  stdenvNoCC,
  appimageTools,
  fetchurl,
  makeWrapper,
  writeShellApplication,
  curl,
  common-updater-scripts,
}:
let
  pname = "clickup";
  version = "3.5.185";

  src = fetchurl {
    # Using archive.org because the website doesn't store older versions of the software.
    url = "https://web.archive.org/web/20260323060753/https://desktop.clickup.com/linux";
    hash = "sha256-szPbhY1vsEG0Zq4TD2I9qVTa4wAUYfoVA2O2xP4HGeE=";
  };

  appimage = appimageTools.wrapType2 {
    inherit pname version src;
    extraPkgs = pkgs: [ pkgs.libxkbfile ];
  };

  appimageContents = appimageTools.extractType2 { inherit pname version src; };
in
stdenvNoCC.mkDerivation {
  inherit pname version;

  src = appimage;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/
    cp -r bin $out/bin

    mkdir -p $out/share/${pname}
    cp -r ${appimageContents}/locales $out/share/${pname}
    cp -r ${appimageContents}/resources $out/share/${pname}
    cp -r --no-preserve=mode ${appimageContents}/usr/share/icons $out/share/
    find $out/share/icons -name desktop.png -execdir mv {} clickup.png \;

    install -m 444 -D ${appimageContents}/desktop.desktop $out/share/applications/clickup.desktop

    substituteInPlace $out/share/applications/clickup.desktop \
      --replace-fail 'Exec=AppRun --no-sandbox %U' 'Exec=clickup' \
      --replace-fail 'Icon=desktop' 'Icon=clickup'

    wrapProgram $out/bin/${pname} \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations,WebRTCPipeWireCapturer}} --no-update"

    runHook postInstall
  '';

  passthru.updateScript = lib.getExe (writeShellApplication {
    name = "update-clickup";
    runtimeInputs = [
      curl
      common-updater-scripts
    ];
    text = ''
      upstream_version="$(curl --silent --location --range 0-0 --dump-header - --output /dev/null https://desktop.clickup.com/linux | grep --only-matching --extended-regexp '[0-9]+\.[0-9]+\.[0-9]+')"

      current_version="$(nix-instantiate --eval --strict -A clickup.version | tr -d '"')"

      if [[ "$current_version" = "$upstream_version" ]]; then
        echo "clickup is already up-to-date at $current_version"
        exit 0
      fi

      echo "Updating clickup from $current_version to $upstream_version"

      echo "Saving new version to archive.org..."
      archived_url="$(curl --silent --max-time 600 --output /dev/null --dump-header - "https://web.archive.org/save/https://desktop.clickup.com/linux" | grep --ignore-case '^location:' | tr -d '\r' | cut -d' ' -f2)"

      if [[ -z "$archived_url" || "$archived_url" != *"web.archive.org/web/"* ]]; then
        echo "error: failed to archive URL on archive.org" >&2
        exit 1
      fi

      update-source-version clickup "$upstream_version" "" "$archived_url"
    '';
  });

  meta = {
    description = "All in one project management solution";
    homepage = "https://clickup.com";
    license = lib.licenses.unfree;
    mainProgram = "clickup";
    maintainers = with lib.maintainers; [ heisfer ];
    platforms = [ "x86_64-linux" ];
  };
}
