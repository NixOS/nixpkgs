# The space wallpaper: a patched shaderbg, the joined shader, the scripts that run it (launcher,
# preview, toggle, and the Hyprland pauser), and systemd user units for them. The settings are
# package arguments, so `.override { fps = 30; }` and the like work. Mirrors package.nix in the
# upstream repository.
{
  lib,
  fetchFromGitHub,
  concatText,
  runCommand,
  symlinkJoin,
  writeShellScriptBin,
  shaderbg,
  coreutils,
  gnused,
  gawk,
  jq,
  socat,
  systemd,
  hyprland,
  # Frames per second the shader renders at.
  fps ? 20,
  # Seconds each scene lasts.
  scenePeriod ? 1800,
  # Share of scene slots that show just the plain sky.
  plainSkyShare ? 0.25,
  # Output space-wallpaper-preview uses when none is given.
  previewOutput ? "DP-1",
  # Include space-wallpaper-pauser (Hyprland only).
  withPauser ? true,
}:

let
  version = "0.1.1";
  src = fetchFromGitHub {
    owner = "JonnyDeates";
    repo = "nix-space-wallpaper";
    tag = "v${version}";
    hash = "sha256-VPB7FfUF2/SR6ArA2LReLtwnvzsAEE9Zug2RLzb1sRo=";
  };

  # Upstream ignores the output scale, so on 2x monitors it renders at half resolution and gets upscaled.
  shaderbgPatched = shaderbg.overrideAttrs (old: {
    # Plus SHADERBG_EPOCH, so a scene swapped in by a new process carries on the same clock.
    patches = (old.patches or [ ]) ++ [
      "${src}/patches/shaderbg-hidpi.patch"
      "${src}/patches/shaderbg-epoch.patch"
    ];
  });

  # GLSL needs definitions before use, so the parts are joined in dependency order.
  joined = concatText "space.frag" [
    "${src}/shaders/common.glsl"
    "${src}/shaders/stars.glsl"
    "${src}/shaders/skies/nebula.glsl"
    "${src}/shaders/skies/milkyway.glsl"
    "${src}/shaders/skies/deepfield.glsl"
    "${src}/shaders/skies/cirrus.glsl"
    "${src}/shaders/sky.glsl"
    "${src}/shaders/bodies.glsl"
    "${src}/shaders/events/solar-system.glsl"
    "${src}/shaders/events/comet.glsl"
    "${src}/shaders/events/black-hole.glsl"
    "${src}/shaders/events/galaxy.glsl"
    "${src}/shaders/events/pillars.glsl"
    "${src}/shaders/events/ring-nebula.glsl"
    "${src}/shaders/events/crab.glsl"
    "${src}/shaders/events/bipolar.glsl"
    "${src}/shaders/events/comet-closeup.glsl"
    "${src}/shaders/events/binary.glsl"
    "${src}/shaders/events/pulsar.glsl"
    "${src}/shaders/events/supernova.glsl"
    "${src}/shaders/events/star-surface.glsl"
    "${src}/shaders/events/galaxy-collision.glsl"
    "${src}/shaders/events/quasar.glsl"
    "${src}/shaders/events/rogue.glsl"
    "${src}/shaders/events/horizon.glsl"
    "${src}/shaders/events/cluster.glsl"
    "${src}/shaders/events/giant.glsl"
    "${src}/shaders/events/planet.glsl"
    "${src}/shaders/events/asteroid-field.glsl"
    "${src}/shaders/events/moon.glsl"
    "${src}/shaders/events/ringplane.glsl"
    "${src}/shaders/events/nebulae/field.glsl"
    "${src}/shaders/events/nebulae/cliffs.glsl"
    "${src}/shaders/events/nebulae/orion.glsl"
    "${src}/shaders/events/nebulae/lagoon.glsl"
    "${src}/shaders/events/nebulae/rosette.glsl"
    "${src}/shaders/events/nebulae/horsehead.glsl"
    "${src}/shaders/events/nebulae/tarantula.glsl"
    "${src}/shaders/events/nebulae/veil.glsl"
    "${src}/shaders/events/nebulae/rho.glsl"
    "${src}/shaders/events/nebulae/forge.glsl"
    "${src}/shaders/events/shower.glsl"
    "${src}/shaders/meteors.glsl"
    "${src}/shaders/main.glsl"
  ];

  # A GLSL float literal for a Nix number.
  glslFloat = x: if builtins.isInt x then "${toString x}.0" else toString x;

  # The settings written into the shader. Only lines that differ from the defaults are touched, so
  # the default build is the shader exactly as written.
  settingsSed = lib.concatStrings [
    (lib.optionalString (scenePeriod != 1800)
      " -e 's/^const float EVENT_PERIOD = 1800.0;/const float EVENT_PERIOD = ${glslFloat scenePeriod};/'"
    )
    (lib.optionalString (plainSkyShare != 0.25)
      " -e 's/^const float PLAIN_SKY_SHARE = 0.25;/const float PLAIN_SKY_SHARE = ${glslFloat plainSkyShare};/'"
    )
  ];
  spaceShader =
    if settingsSed == "" then
      joined
    else
      runCommand "space.frag" { } "${gnused}/bin/sed${settingsSed} ${joined} > $out";

  # Seeds are whole numbers 0-99999 (the shader gets seed / 100). Uses $seed if set, otherwise a
  # random one, and prints it so a scene you like can be brought back.
  pickSeed = ''
    if [ -n "$seed" ]; then
      case "$seed" in
        *[!0-9]*)
          echo "seed must be a whole number" >&2
          exit 1
          ;;
      esac
      seed=$((10#$seed % 100000))
    else
      seed=$(( $(${coreutils}/bin/od -An -N4 -tu4 /dev/urandom) % 100000 ))
    fi
    echo "seed: $seed"
  '';
  # Event ids, odds and names, read from the shader at build time: pickEvent pairs each *_CHANCE
  # with an EV_*, and the name is the EV_ name in lower case. One "id weight name" line per scene,
  # plus "plain <share>". The launcher rolls from it and the preview looks names up in it.
  eventTable = runCommand "space-wallpaper-events" { } ''
    ${gawk}/bin/awk '
      /^const int EV_[A-Z]+ = [0-9]+;/ { n = $3; sub(/^EV_/, "", n); v = $5; sub(/;/, "", v); id[n] = v }
      /^const float [A-Z]+_CHANCE = / { w = $5; sub(/;/, "", w); ch[$3] = w }
      /^const float PLAIN_SKY_SHARE = / { p = $5; sub(/;/, "", p); print "plain", p }
      /^int pickEvent/ { inPick = 1 }
      inPick && /_CHANCE;/ { match($0, /[A-Z]+_CHANCE/); last = substr($0, RSTART, RLENGTH) }
      inPick && /return EV_/ && last != "" { match($0, /EV_[A-Z]+/); e = substr($0, RSTART + 3, RLENGTH - 3); print id[e], ch[last], tolower(e); last = "" }
      inPick && /^}/ { inPick = 0 }
    ' ${spaceShader} > $out
  '';

  seedSed = "s|const float RANDOM_SEED = 0.0;|const float RANDOM_SEED = $seed.0 / 100.0;|";

  # Runs the wallpaper on one output with this launch's seed ($SPACE_WALLPAPER_SEED, or random).
  # One shader holding every scene takes the GPU driver 20+ seconds to compile, so each scene runs
  # as its own shader with just that scene compiled in (a few seconds). This script picks each
  # scene, and near the end of a slot - during its plain-sky gap - starts the next scene's shader,
  # then stops the old one once the new one is drawing. All of them share one clock
  # (SHADERBG_EPOCH), so the sky carries on seamlessly across the swap.
  launch = writeShellScriptBin "space-wallpaper-launch" ''
    output=$1
    if [ -z "$output" ]; then
      echo "usage: space-wallpaper-launch <output>" >&2
      exit 1
    fi
    seed=''${SPACE_WALLPAPER_SEED:-}
    ${pickSeed}
    dir="$XDG_RUNTIME_DIR/space-wallpaper"
    ${coreutils}/bin/mkdir -p "$dir"
    base="$dir/$output.frag"
    # One clock for every scene's shader.
    export SHADERBG_EPOCH=''${EPOCHREALTIME%.*}
    ${gnused}/bin/sed -e "${seedSed}" ${spaceShader} > "$base"

    # Event ids, odds and names (see eventTable).
    table=$(${coreutils}/bin/cat ${eventTable})
    period=$(${gawk}/bin/awk '/^const float EVENT_PERIOD = / { v = $5; sub(/;/, "", v); print int(v) }' "$base")
    gap=$(${gawk}/bin/awk '/^const float SWAP_GAP = / { v = $5; sub(/;/, "", v); print int(v) }' "$base")
    outHash=$(printf %s "$output" | ${coreutils}/bin/cksum | ${coreutils}/bin/cut -d' ' -f1)

    # Which event slot k shows: id and name, the same every time for this seed and output.
    pick() {
      printf '%s\n' "$table" | ${gawk}/bin/awk -v s="$seed" -v k="$1" -v o="$outHash" '
        $1 == "plain" { plain = $2; next }
        { ids[++n] = $1; ws[n] = $2; nm[n] = $3; tot += $2 }
        END {
          srand((s * 7919 + k * 104729 + o) % 2147483647); r = rand()
          if (r < plain) { print 0, "plain"; exit }
          x = (r - plain) / (1 - plain) * tot
          for (i = 1; i <= n; i++) { x -= ws[i]; if (x < 0) { print ids[i], nm[i]; exit } }
          print ids[n], nm[n]
        }'
    }

    # Take the scene shaders down with this script, however it ends.
    trap 'kill $(jobs -p) 2>/dev/null' EXIT
    trap 'exit 0' TERM INT
    cur=""
    curSlot=-1
    old=""
    killAt=0
    while true; do
      t=$(( ''${EPOCHREALTIME%.*} - SHADERBG_EPOCH ))
      k=$(( t / period ))
      # Hand over to the next slot's scene a moment into this slot's plain-sky gap.
      want=$k
      if [ $t -ge $(( (k + 1) * period - gap + 2 )) ]; then
        want=$(( k + 1 ))
      fi
      if [ "$want" != "$curSlot" ]; then
        read -r id name <<< "$(pick "$want")"
        frag="$dir/$output-$want.frag"
        # The sky changes at local midnight: today's date as a day number, and when the next
        # midnight falls in shader time (asked of date, so 23- and 25-hour days come out right).
        today=$(${coreutils}/bin/date +%F)
        skyDay=$(( $(${coreutils}/bin/date -d "$today" +%s) / 86400 ))
        skyNext=$(( $(${coreutils}/bin/date -d "$today + 1 day" +%s) - SHADERBG_EPOCH ))
        ${gnused}/bin/sed -e "s/const int FORCE_EVENT = -1;/const int FORCE_EVENT = $id;/" \
          -e "s/const float SHOW_FROM = -1.0e9;/const float SHOW_FROM = $(( want * period )).0;/" \
          -e "s/const float SHOW_UNTIL = 1.0e9;/const float SHOW_UNTIL = $(( (want + 1) * period - gap )).0;/" \
          -e "s/const float SKY_DAY = 0.0;/const float SKY_DAY = $skyDay.0;/" \
          -e "s/const float SKY_NEXT = 1.0e9;/const float SKY_NEXT = $skyNext.0;/" \
          "$base" > "$frag"
        echo "slot $want: $name"
        ${shaderbgPatched}/bin/shaderbg --fps ${toString fps} --layer background "$output" "$frag" &
        if [ -n "$cur" ]; then
          old=$cur
          oldFrag=$curFrag
          # Long enough for the new shader to compile and start drawing.
          killAt=$(( t + 20 ))
        fi
        cur=$!
        curFrag=$frag
        curSlot=$want
      fi
      if [ -n "$old" ] && [ $t -ge $killAt ]; then
        # Continue it too: if the pauser has it stopped, it would only act on the TERM when continued.
        kill "$old" 2>/dev/null
        kill -CONT "$old" 2>/dev/null
        wait "$old" 2>/dev/null
        ${coreutils}/bin/rm -f "$oldFrag"
        old=""
      fi
      # If the scene's shader died, exit so systemd restarts the wallpaper.
      if ! kill -0 "$cur" 2>/dev/null; then
        echo "shaderbg exited" >&2
        exit 1
      fi
      ${coreutils}/bin/sleep 2
    done
  '';

  # Show one event, or one kind of background sky, on demand instead of waiting for the roll.
  preview = writeShellScriptBin "space-wallpaper-preview" ''
    skies="nebula milkyway deepfield cirrus void"
    # Scene names in id order, from the shader's event table.
    events=$(${gawk}/bin/awk '$1 != "plain"' ${eventTable} | ${coreutils}/bin/sort -n | ${gawk}/bin/awk '{ print $3 }' | ${coreutils}/bin/tr '\n' ' ')
    if [ $# -lt 1 ]; then
      echo "usage: space-wallpaper-preview <event|sky> [output] [seconds] [seed]"
      echo "events: $events"
      echo "skies: $skies"
      exit 1
    fi
    id=0
    extra=""
    sky=-1
    for s in $skies; do
      sky=$((sky + 1))
      if [ "$s" = "$1" ]; then
        # A background sky on its own, with no event.
        name=$1
        id=0
        extra="s/const int FORCE_SKY = -1;/const int FORCE_SKY = $sky;/"
        break
      fi
    done
    if [ -z "$extra" ]; then
      name=$1
      id=$(${gawk}/bin/awk -v n="$1" '$3 == n { print $1 }' ${eventTable})
    fi
    if [ -z "$extra" ] && [ -z "$id" ]; then
      echo "unknown event '$1'; events: $events; skies: $skies"
      exit 1
    fi
    output=''${2:-${previewOutput}}
    seconds=''${3:-20}
    seed=''${4:-}
    ${pickSeed}
    frag=$(mktemp --suffix=.frag)
    trap 'rm -f "$frag"' EXIT
    ${gnused}/bin/sed -e "s/const int FORCE_EVENT = -1;/const int FORCE_EVENT = $id;/" \
      -e 's/const float EVENT_FADE = 20.0;/const float EVENT_FADE = 0.001;/' \
      -e "${seedSed}" -e "s/const float SKY_DAY = 0.0;/const float SKY_DAY = $seed.0;/" \
      -e "$extra" ${spaceShader} > "$frag"
    ${coreutils}/bin/timeout "$seconds" ${shaderbgPatched}/bin/shaderbg --fps ${toString fps} --layer overlay "$output" "$frag"
    true
  '';

  # Freeze a monitor's shader (0 fps) while anything is open on it: a window on its active workspace,
  # or a special (scratchpad) workspace shown over it. It only animates on an empty desktop.
  pauser = writeShellScriptBin "space-wallpaper-pauser" ''
    export PATH=${
      lib.makeBinPath [
        coreutils
        jq
        socat
        systemd
        hyprland
      ]
    }:$PATH

    # Signal just the shaderbg processes of a monitor's wallpaper unit, not its launcher: the launcher
    # keeps scenes swapping on time behind the windows. Plain kill, not systemctl kill, which logs a
    # line for every process on every check.
    signal() {
      cg=$(systemctl --user show -P ControlGroup "space-wallpaper@$1.service")
      [ -n "$cg" ] || return 0
      for pid in $(cat "/sys/fs/cgroup$cg/cgroup.procs" 2>/dev/null); do
        if [ "$(cat "/proc/$pid/comm" 2>/dev/null)" = shaderbg ]; then
          kill -s "$2" "$pid" 2>/dev/null || true
        fi
      done
    }

    update() {
      workspaces=$(hyprctl -j workspaces)
      hyprctl -j monitors | jq -r '.[] | "\(.name) \(.activeWorkspace.id) \(.specialWorkspace.id // 0)"' | while read -r mon ws special; do
        busy=$(jq --argjson id "$ws" --argjson sp "$special" \
          'any(.[]; (.id == $id or ($sp != 0 and .id == $sp)) and .windows > 0)' <<<"$workspaces")
        if [ "$busy" = true ]; then
          sig=STOP
        else
          sig=CONT
        fi
        signal "$mon" "$sig"
      done
    }

    update
    # Also recheck periodically: a wallpaper instance that restarts behind a window
    # starts unpaused, and no Hyprland event fires for that.
    (while sleep 5; do update; done) &
    socat -U - "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" | while read -r event; do
      case "$event" in
        fullscreen\>\>* | workspace\>\>* | focusedmon\>\>* | openwindow\>\>* | closewindow\>\>* | movewindow\>\>* | moveworkspace\>\>* | activespecial\>\>*)
          update
          ;;
      esac
    done
  '';

  toggle = writeShellScriptBin "space-wallpaper-toggle" ''
    if ${systemd}/bin/systemctl --user is-active --quiet space-wallpaper.target; then
      ${systemd}/bin/systemctl --user stop space-wallpaper.target
    else
      ${systemd}/bin/systemctl --user start space-wallpaper.target
    fi
  '';

  # systemd user units, so it runs without Home Manager too: enable one instance per monitor
  # (`systemctl --user enable --now space-wallpaper@DP-1`) and they all start with the graphical
  # session, under space-wallpaper.target (what space-wallpaper-toggle starts and stops). The Home
  # Manager module writes its own copies of these, with its options applied.
  restart = ''
    Restart=always
    RestartSec=2
  '';
  units = runCommand "space-wallpaper-units" { } ''
    mkdir -p $out/lib/systemd/user
    cd $out/lib/systemd/user
    cat > space-wallpaper.target <<'EOF'
    [Unit]
    Description=Animated space wallpaper
    PartOf=graphical-session.target
    After=graphical-session.target
    ${lib.optionalString withPauser "Wants=space-wallpaper-pauser.service"}

    [Install]
    WantedBy=graphical-session.target
    EOF
    cat > space-wallpaper@.service <<'EOF'
    [Unit]
    Description=Animated space wallpaper on %i
    PartOf=space-wallpaper.target
    After=graphical-session.target
    StartLimitIntervalSec=0

    [Service]
    ExecStart=${launch}/bin/space-wallpaper-launch %i
    ${restart}
    [Install]
    WantedBy=space-wallpaper.target
    Also=space-wallpaper.target
    EOF
    ${lib.optionalString withPauser ''
      cat > space-wallpaper-pauser.service <<'EOF'
      [Unit]
      Description=Pause the space wallpaper behind open windows
      PartOf=space-wallpaper.target
      After=graphical-session.target
      StartLimitIntervalSec=0

      [Service]
      ExecStart=${pauser}/bin/space-wallpaper-pauser
      ${restart}
      EOF
    ''}
  '';

  # The joined shader and event table, installed for testing and for anyone building on them.
  data = runCommand "space-wallpaper-data" { } ''
    mkdir -p $out/share/space-wallpaper
    cp ${spaceShader} $out/share/space-wallpaper/space.frag
    cp ${eventTable} $out/share/space-wallpaper/events
  '';
in
symlinkJoin {
  pname = "space-wallpaper";
  inherit version;
  strictDeps = true;
  __structuredAttrs = true;
  paths = [
    launch
    preview
    toggle
    data
    units
  ]
  ++ lib.optional withPauser pauser;
  passthru = {
    shader = spaceShader;
    inherit eventTable;
    shaderbg = shaderbgPatched;
  };
  meta = {
    homepage = "https://github.com/JonnyDeates/nix-space-wallpaper";
    description = "Animated space wallpaper for Wayland: a GLSL starfield with a new scene every half hour";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "space-wallpaper-launch";
    maintainers = with lib.maintainers; [ jonnydeates ];
  };
}
