{
  lib,
  symlinkJoin,
  writeShellScriptBin,
  makeDesktopItem,
  copyDesktopItems,
  wineWow64Packages,
  winetricks,
}:

let
  version = "25.1";
  wine = wineWow64Packages.full;
  winePrefix = "$HOME/.local/share/cadence-allegro";

  wineEnv = ''
    export WINEPREFIX="${winePrefix}"
    export WINEARCH=win64
    export WINEDLLOVERRIDES="mscoree=n;mshtml=n"
    export PATH="${wine}/bin:$PATH"
  '';

  allegro-install = writeShellScriptBin "allegro-install" ''
    set -euo pipefail
    ${wineEnv}

    installer="''${1:-}"
    if [ -z "$installer" ]; then
      echo "Usage: allegro-install <path-to-installer.exe>"
      echo ""
      echo "Download the Allegro X Free Viewer installer from:"
      echo "  https://www.cadence.com/en_US/home/tools/pcb-design-and-analysis/allegro-downloads-start.html"
      exit 1
    fi

    if [ ! -f "$installer" ]; then
      echo "Error: file not found: $installer"
      exit 1
    fi

    echo "==> Wine prefix: $WINEPREFIX"

    if [ ! -d "$WINEPREFIX" ]; then
      echo "==> Initializing Wine prefix..."
      ${wine}/bin/wineboot --init
      ${winetricks}/bin/winetricks -q corefonts vcrun2019 dotnet48
      echo "==> Wine prefix ready."
    fi

    echo "==> Running installer: $installer"
    ${wine}/bin/wine "$installer"
    echo "==> Done. Run 'allegro-run' to launch the viewer."
  '';

  allegro-run = writeShellScriptBin "allegro-run" ''
    set -euo pipefail
    ${wineEnv}

    if [ ! -d "$WINEPREFIX" ]; then
      echo "Error: Wine prefix not found at $WINEPREFIX"
      echo "Run 'allegro-install <installer.exe>' first."
      exit 1
    fi

    cadence_root="$WINEPREFIX/drive_c"
    exe=""

    for candidate in \
      "$cadence_root/Cadence/"*/tools/bin/allegro_free_viewer.exe \
      "$cadence_root/Cadence/"*/tools/bin/allegro_free_viewer_classic.exe \
      "$cadence_root/Cadence/"*/tools/bin/allegro.exe \
      "$cadence_root/Cadence/Allegro_X_Free_Viewer"*/tools/bin/allegro.exe \
      "$cadence_root/Cadence/Allegro"*/tools/bin/allegro.exe \
      "$cadence_root/Cadence/"*/tools/pcb/bin/allegro.exe \
      "$cadence_root/Program Files/Cadence/"*/tools/bin/allegro_free_viewer.exe \
      "$cadence_root/Program Files/Cadence/"*/tools/bin/allegro.exe \
      "$cadence_root/Program Files/Cadence/"*/tools/pcb/bin/allegro.exe \
      "$cadence_root/Cadence/SPB_"*/tools/bin/allegro.exe \
    ; do
      if [ -f "$candidate" ]; then
        exe="$candidate"
        break
      fi
    done

    if [ -z "$exe" ]; then
      echo "Could not find allegro.exe in the Wine prefix."
      echo "Searching for any Cadence executables..."
      find "$cadence_root" -iname '*.exe' -path '*/Cadence/*' 2>/dev/null | head -20
      echo ""
      echo "You can run a specific exe with: allegro-exec <path-to-exe>"
      exit 1
    fi

    echo "==> Launching: $exe"
    ${wine}/bin/wine "$exe" "$@"
  '';

  allegro-exec = writeShellScriptBin "allegro-exec" ''
    set -euo pipefail
    ${wineEnv}

    exe="''${1:-}"
    if [ -z "$exe" ]; then
      echo "Usage: allegro-exec <path-to-exe> [args...]"
      exit 1
    fi
    shift
    ${wine}/bin/wine "$exe" "$@"
  '';

  allegro-winetricks = writeShellScriptBin "allegro-winetricks" ''
    set -euo pipefail
    ${wineEnv}
    ${winetricks}/bin/winetricks "$@"
  '';

  allegro-winecfg = writeShellScriptBin "allegro-winecfg" ''
    set -euo pipefail
    ${wineEnv}
    ${wine}/bin/winecfg "$@"
  '';
  desktopItem = makeDesktopItem {
    name = "cadence-allegro-free";
    desktopName = "Cadence Allegro Viewer";
    comment = "Cadence Allegro X Free PCB Viewer (Wine)";
    exec = "allegro-run";
    icon = "applications-engineering";
    categories = [ "Electronics" "Engineering" "Science" ];
    terminal = false;
  };
in
symlinkJoin {
  name = "cadence-allegro-free-${version}";

  paths = [
    allegro-install
    allegro-run
    allegro-exec
    allegro-winetricks
    allegro-winecfg
    desktopItem
  ];

  meta = {
    description = "Wine wrapper scripts for Cadence Allegro X Free PCB Viewer";
    longDescription = ''
      Provides wrapper scripts to install and run the Cadence Allegro X Free
      Viewer under Wine on Linux. The viewer itself is proprietary and must be
      downloaded separately from Cadence's website.

      Usage:
        1. Download the installer from:
           https://www.cadence.com/en_US/home/tools/pcb-design-and-analysis/allegro-downloads-start.html
        2. Run: allegro-install <path-to-installer.exe>
        3. Run: allegro-run
    '';
    homepage = "https://www.cadence.com/en_US/home/tools/pcb-design-and-analysis/allegro-downloads-start.html";
    license = lib.licenses.unfree;
    mainProgram = "allegro-run";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
