{ stdenv
, lib
, pkgs
, makeWrapper
, electron
, asar
, makeDesktopItem
, copyDesktopItems
, name ? "electron-wrapper"
, desktopName ? name
, url ? "about:blank"
, description ? "This is a wrapper for Electron"
, icon ? null
}:

stdenv.mkDerivation rec {
  pname = name;
  version = "0.0.1";

  src = pkgs.writeText "main.js" ''
    const { app, BrowserWindow, desktopCapturer, dialog, session, screen, shell } = require("electron");
    const path = require("path");
    const fs = require("fs");

    const windowStorage = path.join(app.getPath("userData"), "window.json");

    app.on("ready", () => {

      // Restore window position and size if available
      let { x, y, width, height } = { x: undefined, y: undefined, width: 1000, height: 800 };

      try {
        ({ x, y, width, height } = JSON.parse(fs.readFileSync(windowStorage)));
      } catch (e) {}

      // Check if window is offscreen
      if (x || y) {
        const screens = screen.getAllDisplays();

        // Reset position as app header is completely offscreen
        if (screens.every(({ bounds }) => x + width < bounds.x || bounds.x + bounds.width < x || y < bounds.y || bounds.y + bounds.height < y)) {
          x = undefined;
          y = undefined;

          width = 1000;
          height = 800;
        }
      }

      // Spawn main window
      const window = new BrowserWindow({
        title: "${desktopName}",
        x, y, width, height,
        minWidth: 800, minHeight: 600,
        show: false,
        autoHideMenuBar: true,
        webPreferences: {
          contextIsolation: true,
          nodeIntegration: false,
          spellcheck: true
        }
      });

      // Load provided URL
      window.loadURL("${url}", { userAgent: "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36" });

      window.once("ready-to-show", () => {

        window.show();

        // Handle all important window events
        [ "resize", "move" ].forEach(event => window.on(event, () => { ({ x, y, width, height } = window.getNormalBounds()) }));

        // Store window position and size on close
        window.on("close", () => { fs.writeFileSync(windowStorage, JSON.stringify({ x, y, width, height })) });
      });

      // Handle external links
      window.webContents.setWindowOpenHandler(({ url }) => {
        shell.openExternal(url);
        return { action: "deny" };
      });

      // Enable spell checking
      window.webContents.session.setSpellCheckerLanguages([ "en-US", "de-DE" ]);

      // Handle desktop capture
      session.defaultSession.setDisplayMediaRequestHandler(async (request, callback) => {

        // Show window picker to select source
        const sources = await desktopCapturer.getSources({ types: [ "screen" ] });

        const selection = await dialog.showMessageBox(window, {
          type: "question",
          title: "Select Screen",
          message: "Please select the screen you want to share.",
          buttons: [ "Cancel", ...sources.map(({ name }) => name) ],
          defaultId: 0
        });

        if (selection.response) {
          const source = sources[selection.response - 1];
          callback({ video: source, audio: "loopback" });
        }
        else {
          callback(null);
        }
      }, { useSystemPicker: true });
    });
  '';
  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper asar copyDesktopItems ];

  installPhase = ''
    runHook preInstall

    # Generate executable
    # Add package.json to apply title and icon to window
    mkdir -p $out/lib/${pname}
    cp $src $out/lib/${pname}/main.js
    cat > $out/lib/${pname}/package.json <<EOF
    {
      "name": "${pname}",
      "version": "${version}",
      "main": "main.js"
    }
    EOF
    asar pack $out/lib/${pname} $out/lib/app.asar

    makeWrapper "${lib.getExe electron}" "$out/bin/${pname}" \
      --add-flags $out/lib/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
      --set-default ELECTRON_IS_DEV 0 \
      --inherit-argv0

    # Prepare desktop item
    install -Dm644 "${icon}" "$out/share/pixmaps/${pname}.png"

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      desktopName = desktopName;
      comment = meta.description;
      exec = pname;
      icon = pname;
      terminal = false;
    })
  ];

  meta = with lib; {
    description = description;
    homepage = url;
    maintainers = with maintainers; [ David-Kopczynski ];
    platforms = lib.platforms.linux;
    mainProgram = pname;
  };
}