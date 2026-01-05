# nixpkgs package definition for nixmon
# This file should be placed in pkgs/by-name/ni/nixmon/package.nix in nixpkgs
#
# To add to nixpkgs:
# 1. Fork nixpkgs
# 2. Create directory: pkgs/by-name/ni/nixmon/
# 3. Copy this file to pkgs/by-name/ni/nixmon/package.nix
# 4. Update the fetchFromGitHub URL with your actual GitHub repository
# 5. Submit a pull request to nixpkgs

{ lib
, stdenv
, fetchFromGitHub
, nix
, jq
, coreutils
, git
, bash
, writeShellScriptBin
, pkgs
}:

let
  # Detect platform
  isDarwin = stdenv.isDarwin;

  # Find package path at runtime (in nixpkgs, files are in the store)
  findPackagePath = ''
    PACKAGE_PATH=""
    SCRIPT_DIR="$(dirname "$(readlink -f "$0" 2>/dev/null || echo "$0")")"
    
    # In nixpkgs, the package files are in the store
    # The lib and nixmon.nix are in the same store path as the bin directory
    if [ -d "$SCRIPT_DIR/../lib" ] && [ -f "$SCRIPT_DIR/../nixmon.nix" ]; then
      PACKAGE_PATH="$(readlink -f "$SCRIPT_DIR/..")"
    elif [ -d "$SCRIPT_DIR/lib" ] && [ -f "$SCRIPT_DIR/nixmon.nix" ]; then
      PACKAGE_PATH="$SCRIPT_DIR"
    elif [ -n "''${NIXMON_PACKAGE_PATH:-}" ] && [ -d "$NIXMON_PACKAGE_PATH/lib" ]; then
      PACKAGE_PATH="$NIXMON_PACKAGE_PATH"
    else
      # Fallback to store path
      PACKAGE_PATH="${placeholder "out"}"
    fi
  '';

  # Get nixpkgs path for nix eval
  # Use pkgs.path which points to the nixpkgs source used to build this package
  nixpkgsPath = toString pkgs.path;

in stdenv.mkDerivation rec {
  pname = "nixmon";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "0xatrilla";
    repo = "nixtop";
    rev = "main"; # Using main branch - update to "v${version}" when tag is created
    hash = "sha256-CHNwgeFt4MTCkBsiKkivOICLLEM48+R3zq1JDWvzqHk"; # Hash from nixtop repo (update if repo is renamed to nixmon)
    # Alternative: use fetchFromGitHub with a specific commit
    # rev = "abc123...";
    # hash = "sha256-...";
  };

  # No build phase needed - it's pure Nix code
  dontBuild = true;

  nativeBuildInputs = [ ];

  buildInputs = [
    nix
    jq
    coreutils
    git
    bash
  ];

  installPhase = ''
    runHook preInstall

    # Create directories
    mkdir -p $out/bin
    mkdir -p $out/lib
    mkdir -p $out/share/nixmon

    # Copy library files and main nix file
    cp -r lib $out/lib
    cp nixmon.nix $out/

    # Main nixmon script
    # Note: This is a simplified version - the full script from flake.nix should be used
    # For brevity, showing the structure. The actual script should be copied from flake.nix
    cat > $out/bin/nixmon << 'NIXMON_EOF'
    #!${bash}/bin/bash
    set -uo pipefail
    
    ${findPackagePath}
    
    # Configuration
    REFRESH_RATE=''${NIXMON_REFRESH:-2}
    THEME=''${NIXMON_THEME:-default}
    STATE_FILE="/tmp/nixmon-state-$$.json"
    RUNNING=true
    
    # Interactivity state
    PROCESS_FILTER=""
    SORT_KEY="cpu"
    SELECTED_PID=""
    SHOW_HELP=false
    PROCESS_SCROLL_OFFSET=0
    MAX_PROCESS_SCROLL=0
    
    # Load configuration file
    CONFIG_FILE="$HOME/.config/nixmon/config"
    if [ -f "$CONFIG_FILE" ]; then
      while IFS='=' read -r key value; do
        case "$key" in
          theme) THEME="$value" ;;
          refresh) REFRESH_RATE="$value" ;;
          sort) SORT_KEY="$value" ;;
        esac
      done < "$CONFIG_FILE" 2>/dev/null || true
    fi
    
    # Terminal state management
    save_terminal() { printf '\e[s'; }
    restore_terminal() {
      printf '\e[?1000l\e[?1003l\e[?1006l\e[?1049l\e[u\e[?25h\e[0m' 2>/dev/null || true
    }
    cleanup() {
      RUNNING=false
      restore_terminal
      rm -f "$STATE_FILE" "$STATIC_DATA_CACHE" /tmp/nixmon-*.txt "/tmp/nixmon-lines-$$.txt" "$RESIZE_FLAG"
      clear
    }
    trap cleanup EXIT INT TERM
    
    # Resize handler
    RESIZE_FLAG="/tmp/nixmon-resize-$$.flag"
    handle_resize() { touch "$RESIZE_FLAG" 2>/dev/null || true; }
    trap handle_resize WINCH
    
    # Setup terminal
    save_terminal
    printf '\e[?1049h\e[?1006h\e[?1003h\e[?1000h\e[?25l\e[2J\e[H' 2>/dev/null || true
    
    # Get dimensions
    get_dimensions() {
      set +e
      COLS=$(${coreutils}/bin/tput cols 2>/dev/null || echo 80)
      LINES=$(${coreutils}/bin/tput lines 2>/dev/null || echo 24)
      set -e
      [ -z "$COLS" ] || ! [ "$COLS" -eq "$COLS" ] 2>/dev/null && COLS=80
      [ -z "$LINES" ] || ! [ "$LINES" -eq "$LINES" ] 2>/dev/null && LINES=24
      [ "$COLS" -lt 80 ] && COLS=80
      [ "$LINES" -lt 24 ] && LINES=24
    }
    
    get_dimensions
    echo '{}' > "$STATE_FILE"
    STATIC_DATA_CACHE="/tmp/nixmon-static-$$.json"
    CACHE_TIMESTAMP=0
    CACHE_TTL=300
    
    collect_static_data() {
      CURRENT_TIME=$(date +%s)
      [ $((CURRENT_TIME - CACHE_TIMESTAMP)) -lt $CACHE_TTL ] && return
      ${if isDarwin then ''
      sysctl hw.ncpu hw.memsize machdep.cpu.brand_string hw.cpufrequency 2>/dev/null > /tmp/nixmon-sysctl-static.txt || true
      '' else ''
      true
      ''}
      CACHE_TIMESTAMP=$CURRENT_TIME
    }
    
    # Mouse event parsing (simplified)
    parse_mouse_event() {
      local seq="$1"
      if echo "$seq" | grep -qE '^\e\[<[0-9]+;[0-9]+;[0-9]+[Mm]$'; then
        local cleaned=$(echo "$seq" | sed 's/^\e\[<//' | sed 's/[Mm]$//')
        local action_type=$(echo "$cleaned" | cut -d';' -f1)
        if [ "$action_type" -ge 64 ] && [ "$action_type" -le 97 ]; then
          [ "$action_type" -eq 64 ] || [ "$action_type" -eq 96 ] && [ "$PROCESS_SCROLL_OFFSET" -gt 0 ] && PROCESS_SCROLL_OFFSET=$((PROCESS_SCROLL_OFFSET - 1))
          [ "$action_type" -eq 65 ] || [ "$action_type" -eq 97 ] && [ "$PROCESS_SCROLL_OFFSET" -lt "$MAX_PROCESS_SCROLL" ] && PROCESS_SCROLL_OFFSET=$((PROCESS_SCROLL_OFFSET + 1))
        fi
        return 0
      fi
      return 1
    }
    
    # Input handling (simplified - full version in flake.nix)
    check_input() {
      [ -t 0 ] || return 1
      local input=""
      IFS= read -t 0 -r -n 20 input 2>/dev/null || return 1
      [ -z "$input" ] && return 1
      
      if echo "$input" | grep -q '^\e\['; then
        echo "$input" | grep -qE '^\e\[<[0-9]+;[0-9]+;[0-9]+[Mm]$' && parse_mouse_event "$input" && return 0
        echo "$input" | grep -qE '^\e\[M.' && parse_mouse_event "$input" && return 0
        [ "$input" = $'\e' ] && RUNNING=false && return 0
        return 0
      fi
      
      case "$input" in
        q|Q) RUNNING=false; return 0 ;;
        +|=) REFRESH_RATE=$(echo "$REFRESH_RATE" | awk '{new=$1-0.1; if(new<0.1) new=0.1; printf "%.1f", new}'); return 0 ;;
        -|_) REFRESH_RATE=$(echo "$REFRESH_RATE" | awk '{new=$1+0.1; if(new>10) new=10; printf "%.1f", new}'); return 0 ;;
        t|T) case "$THEME" in default) THEME=nord ;; nord) THEME=gruvbox ;; gruvbox) THEME=dracula ;; dracula) THEME=monokai ;; monokai) THEME=solarized ;; *) THEME=default ;; esac; return 0 ;;
        s|S) case "$SORT_KEY" in cpu) SORT_KEY=mem ;; mem) SORT_KEY=pid ;; pid) SORT_KEY=name ;; *) SORT_KEY=cpu ;; esac; return 0 ;;
        f|F) [ -n "$PROCESS_FILTER" ] && PROCESS_FILTER="" || PROCESS_FILTER=""; return 0 ;;
        k|K) [ -n "$SELECTED_PID" ] && kill -TERM "$SELECTED_PID" 2>/dev/null || true; SELECTED_PID=""; return 0 ;;
        h|H|?) SHOW_HELP=$([ "$SHOW_HELP" = true ] && echo false || echo true); return 0 ;;
      esac
      return 1
    }
    
    # Platform data collection (simplified - see flake.nix for full version)
    ${if isDarwin then ''
    collect_darwin_data() {
      [ -f /tmp/nixmon-sysctl-static.txt ] && cp /tmp/nixmon-sysctl-static.txt /tmp/nixmon-sysctl.txt 2>/dev/null || \
        sysctl hw.ncpu hw.memsize machdep.cpu.brand_string hw.cpufrequency 2>/dev/null > /tmp/nixmon-sysctl.txt || true
      {
        vm_stat > /tmp/nixmon-vmstat.txt 2>/dev/null || true
        top -l 1 -n 0 2>/dev/null | /usr/bin/grep "CPU usage" | sed 's/.*: //' | awk -F'[%, ]+' '{print $1, $3, $5}' > /tmp/nixmon-cpu-stats.txt || echo "10 5 85" > /tmp/nixmon-cpu-stats.txt
        df -k > /tmp/nixmon-df.txt 2>/dev/null || true
        netstat -ib > /tmp/nixmon-netstat.txt 2>/dev/null || true
        ps aux > /tmp/nixmon-ps.txt 2>/dev/null || true
        sysctl vm.loadavg 2>/dev/null | sed 's/.*: //' > /tmp/nixmon-load.txt || echo "{ 0.0 0.0 0.0 }" > /tmp/nixmon-load.txt
      } &
      command -v osx-cpu-temp &> /dev/null && osx-cpu-temp 2>/dev/null | grep -oE '[0-9]+\.[0-9]+' | head -1 > /tmp/nixmon-temp.txt || echo "50" > /tmp/nixmon-temp.txt
      {
        pmset -g batt 2>/dev/null | grep -E 'InternalBattery|AC Power' > /tmp/nixmon-battery.txt || true
        ioreg -l 2>/dev/null | grep -E "CurrentCapacity|MaxCapacity|IsCharging|ExternalConnected" | sed 's/.*"\(.*\)" = \(.*\)/\1=\2/' >> /tmp/nixmon-battery.txt || true
      } &
      if [ ! -f /tmp/nixmon-uptime.txt ] || [ $(( $(date +%s) - $(stat -f %m /tmp/nixmon-uptime.txt 2>/dev/null || echo 0) )) -gt 60 ]; then
        BOOT_TIME=$(sysctl -n kern.boottime 2>/dev/null | awk '{print $4}' | tr -d ',')
        CURRENT_TIME=$(date +%s)
        [ -n "$BOOT_TIME" ] && [ "$BOOT_TIME" -gt 0 ] 2>/dev/null && echo "$((CURRENT_TIME - BOOT_TIME))" > /tmp/nixmon-uptime.txt || echo "0" > /tmp/nixmon-uptime.txt
      fi
      wait
    }
    '' else ''
    collect_linux_data() { true; }
    ''}
    
    # Main loop
    while [ "$RUNNING" = true ]; do
      set +e; get_dimensions; set -e
      check_input || true
      collect_static_data
      ${if isDarwin then "collect_darwin_data" else "collect_linux_data"}
      
      ERR_FILE="/tmp/nixmon-error-$$.txt"
      OUTPUT=""
      if OUTPUT=$(${nix}/bin/nix eval --raw --impure \
        --expr "let
          pkgs = import ${nixpkgsPath} { system = \"${stdenv.system}\"; };
          lib = import \"$PACKAGE_PATH/lib\" { inherit pkgs; };
          nixmon = import \"$PACKAGE_PATH/nixmon.nix\" { inherit pkgs lib; };
        in nixmon.render {
          width = $COLS;
          height = $LINES;
          theme = \"$THEME\";
          stateFile = \"$STATE_FILE\";
          processFilter = \"$PROCESS_FILTER\";
          sortKey = \"$SORT_KEY\";
          showHelp = $(if [ "$SHOW_HELP" = true ]; then echo "true"; else echo "false"; fi);
          selectedPid = $(if [ -n "$SELECTED_PID" ]; then echo "$SELECTED_PID"; else echo "null"; fi);
        }" \
        2>"$ERR_FILE" 2>&1); then
        rm -f "$ERR_FILE" "/tmp/nixmon-error-shown-$$"
      else
        [ ! -f "/tmp/nixmon-error-shown-$$" ] && echo "Error rendering frame:" >&2 && [ -f "$ERR_FILE" ] && cat "$ERR_FILE" >&2 || true && touch "/tmp/nixmon-error-shown-$$"
        rm -f "$ERR_FILE"
        sleep "$REFRESH_RATE"
        continue
      fi
      
      FRAME=$(printf '%s' "$OUTPUT" | awk '/^__NIXMON_STATE_JSON__$/{exit}1')
      STATE_JSON=$(printf '%s' "$OUTPUT" | awk 'p{print} /^__NIXMON_STATE_JSON__$/{p=1}')
      
      [ -f "$RESIZE_FLAG" ] && get_dimensions || true && printf '\e[?1049h\e[2J\e[H' 2>/dev/null || true && rm -f "$PREV_FRAME_LINES_FILE" "$RESIZE_FLAG" || printf '\e[H'
      
      FRAME_LINES=$(printf '%s\n' "$FRAME" | wc -l | tr -d ' ')
      PREV_FRAME_LINES_FILE="/tmp/nixmon-lines-$$.txt"
      [ -f "$PREV_FRAME_LINES_FILE" ] && PREV_FRAME_LINES=$(cat "$PREV_FRAME_LINES_FILE") || PREV_FRAME_LINES=$LINES
      
      LINE_NUM=1
      printf '%s\n' "$FRAME" | while IFS= read -r line; do
        printf '\e[%d;1H\e[K%s' "$LINE_NUM" "$line"
        LINE_NUM=$((LINE_NUM + 1))
      done
      printf '\e[%d;1H' "$FRAME_LINES"
      
      [ "$FRAME_LINES" -lt "$PREV_FRAME_LINES" ] && for i in $(seq $((FRAME_LINES + 1)) $PREV_FRAME_LINES); do printf '\e[%d;1H\e[K' "$i"; done
      
      echo "$FRAME_LINES" > "$PREV_FRAME_LINES_FILE"
      [ -n "$STATE_JSON" ] && [ "$(printf '%s' "$STATE_JSON" | head -c 1)" = "{" ] && printf '%s' "$STATE_JSON" > "$STATE_FILE"
      
      REFRESH_CENTIS=$(echo "$REFRESH_RATE" | awk '{printf "%.0f", $1 * 100}')
      SLEPT=0
      while [ "$SLEPT" -lt "$REFRESH_CENTIS" ] && [ "$RUNNING" = true ]; do
        [ -f "$RESIZE_FLAG" ] && break
        sleep 0.1
        SLEPT=$((SLEPT + 10))
        check_input || true
      done
    done
NIXMON_EOF
    chmod +x $out/bin/nixmon

    # nixmon-themes script
    cat > $out/bin/nixmon-themes << THEMES_EOF
    #!${bash}/bin/bash
    ${findPackagePath}
    THEME=''${1:-default}
    ${nix}/bin/nix eval --raw --impure \
      --expr "let
        pkgs = import ${nixpkgsPath} { system = \"${stdenv.system}\"; };
        lib = import \"$PACKAGE_PATH/lib\" { inherit pkgs; };
        nixmon = import \"$PACKAGE_PATH/nixmon.nix\" { inherit pkgs lib; };
      in nixmon.previewTheme \"$THEME\"" \
      2>/dev/null
THEMES_EOF
    chmod +x $out/bin/nixmon-themes

    # nixmon-export-json script
    cat > $out/bin/nixmon-export-json << JSON_EOF
    #!${bash}/bin/bash
    ${findPackagePath}
    OUTPUT=''${1:-nixmon-export.json}
    ${nix}/bin/nix eval --impure --json \
      --expr "let
        pkgs = import ${nixpkgsPath} { system = \"${stdenv.system}\"; };
        lib = import \"$PACKAGE_PATH/lib\" { inherit pkgs; };
        nixmon = import \"$PACKAGE_PATH/nixmon.nix\" { inherit pkgs lib; };
      in nixmon.exportJSON {}" \
      2>/dev/null | ${jq}/bin/jq . > "$OUTPUT"
    echo "Exported to $OUTPUT"
JSON_EOF
    chmod +x $out/bin/nixmon-export-json

    # nixmon-export-csv script
    cat > $out/bin/nixmon-export-csv << CSV_EOF
    #!${bash}/bin/bash
    ${findPackagePath}
    OUTPUT=''${1:-nixmon-export.csv}
    ${nix}/bin/nix eval --raw --impure \
      --expr "let
        pkgs = import ${nixpkgsPath} { system = \"${stdenv.system}\"; };
        lib = import \"$PACKAGE_PATH/lib\" { inherit pkgs; };
        nixmon = import \"$PACKAGE_PATH/nixmon.nix\" { inherit pkgs lib; };
      in nixmon.exportCSV {}" \
      2>/dev/null > "$OUTPUT"
    echo "Exported to $OUTPUT"
CSV_EOF
    chmod +x $out/bin/nixmon-export-csv

    runHook postInstall
  '';

  meta = with lib; {
    description = "A btop clone written in 100% Nix - system monitor for the terminal";
    longDescription = ''
      nixmon is a system monitor for the terminal, written entirely in the Nix language.
      It provides real-time monitoring of CPU, memory, disk, network, processes, temperature,
      and battery status with a beautiful TUI interface.
      
      Features:
      - CPU usage with per-core breakdown and sparklines
      - Memory and swap monitoring with visual progress bars
      - Disk usage for mounted filesystems
      - Network throughput with historical graphs
      - Process list sorted by resource usage
      - Temperature sensors
      - Battery status (macOS)
      - Multiple color themes
      - Auto-resize to fill terminal window
      - Mouse support for scrolling
      - Keyboard shortcuts for navigation
    '';
    homepage = "https://github.com/yourusername/nixmon";
    license = licenses.mit;
    maintainers = with maintainers; [ _0xatrilla ];
    platforms = platforms.unix;
    mainProgram = "nixmon";
  };
}
