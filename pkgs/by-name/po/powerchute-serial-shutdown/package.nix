{
  lib,
  stdenv,
  fetchurl,
  writeShellScript,
  autoPatchelfHook,
  rpm,
  libarchive,
  unzip,
  gnutar,
  gnused,
  coreutils,
  curl,
  nix,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "powerchute-serial-shutdown";
  # Upstream ships version.build (see buildnumber.txt in the archive); the
  # download filename instead spells the build as "-301".
  version = "1.6.0.301";

  src = fetchurl {
    # This document reference always resolves to the current release, so
    # updateScript re-fetches it to notice new versions/hashes rather than
    # relying on a version-pinned URL (APC/Schneider Electric do not publish
    # one for this product).
    url = "https://download.se.com/files?p_Doc_Ref=SPD-PCSS_LNX_EN";
    name = "pcssagent-1.6.0-301-EN.x86_64.tar.gz";
    hash = "sha256-0fdD/HVYdgRxqnictrPRaO9gCDD1EFYVoMBUdj6V+js=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    rpm
    libarchive
    unzip
    autoPatchelfHook
  ];

  # autoPatchelf only needs to fix up the JRE and the two vendor .so's; the
  # bundled JRE also carries optional AWT/font-rendering libraries that this
  # headless agent never loads.
  autoPatchelfIgnoreMissingDeps = true;

  buildInputs = [
    stdenv.cc.cc.lib
  ];

  unpackPhase = ''
    runHook preUnpack

    tar -xzf $src
    # The rpm's file metadata marks its directories read-only, which a
    # strict cpio extraction can't then create children under; bsdtar
    # defers applying directory permissions until it is done writing.
    rpm2cpio pcssagent-1.6.0-301-EN.x86_64.rpm | bsdtar -xf - --no-same-permissions --no-same-owner
    chmod -R u+rwX opt

    runHook postUnpack
  '';

  installPhase = ''
        runHook preInstall

        agent="opt/APC/PowerChuteSerialShutdown/Agent"
        dest="$out/share/powerchute-serial-shutdown"

        mkdir -p "$dest/jre"
        unzip -q "$agent/jrelnx.zip" -d "$dest/jre"
        rm -f "$agent/jrelnx.zip"

        mkdir -p "$dest/Agent"
        cp -r "$agent"/. "$dest/Agent"

        mkdir -p "$out/bin"

        # PicardApplication reads/writes several paths (pcssconfig.ini, log/,
        # cmdfiles/, comps.m11, temp/...) relative to its working directory,
        # which upstream's RPM points at its own (mutable) install prefix. The
        # Nix store is read-only, so both entry points instead run from a state
        # directory that they populate on first use by linking in the static
        # pieces from the store and leaving the mutable ones to be created by
        # the application itself. @AGENT@/@JAVA@ are substituted below, after
        # the heredocs, to avoid fighting shell/Nix quoting in this string.
        cat > "$out/bin/.powerchute-serial-shutdown-state.sh" <<'STATESCRIPT'
    state_dir="''${STATE_DIRECTORY:-''${XDG_STATE_HOME:-$HOME/.local/state}/powerchute-serial-shutdown}"
    mkdir -p "$state_dir"
    for entry in @AGENT@/*; do
      name="$(basename "$entry")"
      case "$name" in
        lib|comp|Resources|log|pcssconfig.ini|pcssconfig_backup.ini) continue ;;
      esac
      [ -e "$state_dir/$name" ] || ln -s "$entry" "$state_dir/$name"
    done
    mkdir -p "$state_dir/log/archive"
    cd "$state_dir"
    STATESCRIPT

        cat > "$out/bin/powerchute-serial-shutdown-agent" <<'AGENTSCRIPT'
    #!@SHELL@
    set -e
    . @STATEHELPER@
    exec @JAVA@ \
      -Dpicard.main.thread=blocking \
      -Djava.library.path=@AGENT@/lib/linux64 \
      -classpath "@AGENT@/lib/*:@AGENT@/Resources/*:@AGENT@/comp/*" \
      com.apcc.m11.application.PicardApplication "$@"
    AGENTSCRIPT

        cat > "$out/bin/powerchute-serial-shutdown-config" <<'CONFIGSCRIPT'
    #!@SHELL@
    set -e
    . @STATEHELPER@
    exec @JAVA@ \
      --add-exports java.base/com.sun.crypto.provider=ALL-UNNAMED \
      -jar @AGENT@/lib/pcssconfig.jar "$@"
    CONFIGSCRIPT

        substituteInPlace "$out/bin/.powerchute-serial-shutdown-state.sh" \
          --replace-fail "@AGENT@" "$dest/Agent"

        for f in "$out/bin/powerchute-serial-shutdown-agent" "$out/bin/powerchute-serial-shutdown-config"; do
          substituteInPlace "$f" \
            --replace-fail "@AGENT@" "$dest/Agent" \
            --replace-fail "@JAVA@" "$dest/jre/bin/java" \
            --replace-fail "@STATEHELPER@" "$out/bin/.powerchute-serial-shutdown-state.sh" \
            --replace-fail "@SHELL@" "${stdenv.shell}"
        done

        chmod +x "$out/bin/.powerchute-serial-shutdown-state.sh" \
          "$out/bin/powerchute-serial-shutdown-agent" \
          "$out/bin/powerchute-serial-shutdown-config"

        runHook postInstall
  '';

  passthru.updateScript = writeShellScript "powerchute-serial-shutdown-updater" ''
    set -euo pipefail
    export PATH="${
      lib.makeBinPath [
        rpm
        gnutar
        gnused
        coreutils
        curl
        nix
      ]
    }:$PATH"

    file="pkgs/by-name/po/powerchute-serial-shutdown/package.nix"
    url="https://download.se.com/files?p_Doc_Ref=SPD-PCSS_LNX_EN"
    old_version="$(sed -n 's/.*version = "\(.*\)".*/\1/p' "$file" | head -n1)"

    workdir=$(mktemp -d)
    trap 'rm -rf "$workdir"' EXIT

    # Akamai (fronting download.se.com) blocks the literal string
    # "Mozilla/5.0" as a bot signature but allows curl's own default
    # User-Agent, which is also what nixpkgs' fetchurl sends.
    curl -sL -o "$workdir/pcssagent.tar.gz" "$url"
    tar -xzf "$workdir/pcssagent.tar.gz" -C "$workdir" buildnumber.txt
    new_version="$(tr -d '[:space:]' < "$workdir/buildnumber.txt")"
    new_hash="$(nix hash file --sri "$workdir/pcssagent.tar.gz")"

    if [ "$new_version" = "$old_version" ]; then
      echo "powerchute-serial-shutdown is already up to date ($old_version)"
      exit 0
    fi

    sed -i \
      -e "s|version = \"$old_version\";|version = \"$new_version\";|" \
      -e "s|hash = \"sha256-[^\"]*\";|hash = \"$new_hash\";|" \
      "$file"

    echo "Updated powerchute-serial-shutdown: $old_version -> $new_version"
  '';

  meta = {
    description = "Unattended, graceful shutdown, UPS monitoring and configuration agent for APC/Schneider Electric UPS devices connected over USB/serial";
    longDescription = ''
      PowerChute Serial Shutdown (PCSS) is a Java-based daemon from APC by
      Schneider Electric that monitors a directly-connected (USB or serial)
      Smart-UPS/Easy UPS device and performs a graceful shutdown of the host
      on power events.

      Upstream's RPM writes mutable state (`pcssconfig.ini`, logs, `m11.cfg`)
      next to its read-only application files, which the Nix store doesn't
      allow. Both `powerchute-serial-shutdown-config` and
      `powerchute-serial-shutdown-agent` instead run from a state directory
      (`$STATE_DIRECTORY`, falling back to
      `$XDG_STATE_HOME/powerchute-serial-shutdown` or
      `~/.local/state/powerchute-serial-shutdown`) that they populate with
      symlinks to the static application files on first run. Run the config
      tool once (as root, so it can see the UPS device) before starting the
      agent.
    '';
    homepage = "https://www.se.com/us/en/download/document/SPD-PCSS_LNX_EN/";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ shymega ];
    mainProgram = "powerchute-serial-shutdown-agent";
  };
})
