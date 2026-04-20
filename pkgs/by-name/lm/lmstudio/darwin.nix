{
  stdenv,
  fetchurl,
  undmg,
  darwin,
  meta,
  pname,
  version,
  url,
  hash,
  passthru,
  lms,
  jq,
}:
stdenv.mkDerivation {
  inherit meta pname version;

  src = fetchurl {
    inherit url hash;
  };

  nativeBuildInputs = [
    undmg
    darwin.sigtool
  ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/Applications $out/bin
    cp -r *.app $out/Applications

    # Bypass the /Applications path check in the main index.js
    # LM Studio verifies the app is running from /Applications and shows an
    # error dialog + refuses to auto-update if not. Replace the '/Applications'
    # string literal with '/' so that any absolute path (e.g. /nix/store/...)
    # passes the startsWith check. This works across obfuscated versions because
    # the literal string '/Applications' is stable even when variable names change.
    local indexJs="$out/Applications/LM Studio.app/Contents/Resources/app/.webpack/main/index.js"
    substituteInPlace "$indexJs" --replace-quiet "'/Applications'" "'/'"

    # lms cli tool — built from source via lms.nix
    install -m 755 ${lms}/bin/lms $out/bin/.lms-unwrapped

    # Wrap lms so it can find the LM Studio app from the Nix store.
    # The lms CLI discovers LM Studio via ~/.lmstudio/.internal/app-install-location.json.
    # When LM Studio is installed via Nix this file does not exist, so lms cannot find
    # or start the daemon.  The wrapper ensures the file points to the Nix-packaged app.
    cat > $out/bin/lms <<'WRAPPER'
#!/bin/sh
# Determine LM Studio home the same way the JS code does
if [ -f "$HOME/.lmstudio-home-pointer" ]; then
  LMSTUDIO_HOME=$(cat "$HOME/.lmstudio-home-pointer")
elif [ -d "$HOME/.cache/lm-studio" ]; then
  LMSTUDIO_HOME="$HOME/.cache/lm-studio"
else
  LMSTUDIO_HOME="$HOME/.lmstudio"
fi

install_file="$LMSTUDIO_HOME/.internal/app-install-location.json"

# Only write if the file is missing or points to a non-existent path
needs_update=0
if [ ! -f "$install_file" ]; then
  needs_update=1
elif ! @jq@ -e '.path' "$install_file" >/dev/null 2>&1; then
  needs_update=1
elif [ ! -e "$(@jq@ -r '.path' "$install_file")" ]; then
  needs_update=1
fi

if [ "$needs_update" = 1 ]; then
  mkdir -p "$(dirname "$install_file")"
  printf '{"path":"%s","argv":[],"cwd":"%s"}\n' "@lm_studio@" "@bindir@" > "$install_file"
fi

exec @lms_unwrapped@ "$@"
WRAPPER
    substituteInPlace $out/bin/lms \
      --replace-fail '@jq@' '${jq}/bin/jq' \
      --replace-fail '@lm_studio@' "$out/Applications/LM Studio.app/Contents/MacOS/LM Studio" \
      --replace-fail '@bindir@' "$out/Applications/LM Studio.app/Contents/MacOS" \
      --replace-fail '@lms_unwrapped@' "$out/bin/.lms-unwrapped"
    chmod 755 $out/bin/lms

    # Re-sign the app bundle after patching, otherwise macOS reports it as damaged
    # Re-sign every Mach-O in the bundle so macOS doesn't flag it as damaged.
    # nix's sigtool only handles individual Mach-O files (no --deep, no bundles),
    # so sign each binary individually.
    find "$out/Applications/LM Studio.app" -type f -perm /111 | while read -r f; do
      if file "$f" | grep -q Mach-O; then
        codesign --force --sign - "$f" || true
      fi
    done

    runHook postInstall
  '';

  # LM Studio ships Scripts inside the App Bundle, which may be messed up by standard fixups
  dontFixup = true;

  # undmg doesn't support APFS and 7zz does break the xattr. Took that approach from https://github.com/NixOS/nixpkgs/blob/a3c6ed7ad2649c1a55ffd94f7747e3176053b833/pkgs/by-name/in/insomnia/package.nix#L52
  unpackCmd = ''
    echo "Creating temp directory"
    mnt=$(TMPDIR=/tmp mktemp -d -t nix-XXXXXXXXXX)
    function finish {
      echo "Ejecting temp directory"
      /usr/bin/hdiutil detach $mnt -force
      rm -rf $mnt
    }
    # Detach volume when receiving SIG "0"
    trap finish EXIT
    # Mount DMG file
    echo "Mounting DMG file into \"$mnt\""
    /usr/bin/hdiutil attach -nobrowse -mountpoint $mnt $curSrc
    # Copy content to local dir for later use
    echo 'Copying extracted content into "sourceRoot"'
    cp -a $mnt/LM\ Studio.app $PWD/
  '';

  inherit passthru;
}
