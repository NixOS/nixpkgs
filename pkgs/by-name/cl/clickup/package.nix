{
  lib,
  appimageTools,
  fetchurl,
  makeWrapper,
  writeShellApplication,
  curl,
  common-updater-scripts,
  desktop-file-utils,
}:

appimageTools.wrapType2 (finalAttrs: {
  pname = "clickup";
  version = "3.5.262";

  src = fetchurl {
    # Using archive.org because the website doesn't store older versions of the software.
    url = "https://web.archive.org/web/20260727110257/https://desktop.clickup.com/linux";
    hash = "sha256-8stmEBpvU75JSMBZCjcObLndq+51bqTYb0PK1Yypudc=";
  };

  extraPkgs = pkgs: [
    pkgs.libxkbfile
  ];

  nativeBuildInputs = [
    makeWrapper
    desktop-file-utils
  ];

  extraInstallCommands = ''
    mkdir -p $out/share/clickup
    cp -r ${finalAttrs.contents}/locales $out/share/clickup
    cp -r ${finalAttrs.contents}/resources $out/share/clickup

    cp -r --no-preserve=mode ${finalAttrs.contents}/usr/share/icons $out/share/
    find $out/share/icons -name desktop.png -execdir mv {} clickup.png \;

    install -m 444 -D ${finalAttrs.contents}/desktop.desktop $out/share/applications/clickup.desktop

    desktop-file-edit \
      --set-key=Exec --set-value=clickup \
      --set-key=Icon --set-value=clickup \
      "$out/share/applications/clickup.desktop"

    wrapProgram $out/bin/clickup \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations,WebRTCPipeWireCapturer}} --no-update"
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

      update-source-version clickup "$upstream_version" "" "$archived_url" \
        --source-key=src.src
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
})
