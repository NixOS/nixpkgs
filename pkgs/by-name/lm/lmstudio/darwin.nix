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
    mkdir -p $out/Applications
    cp -r *.app $out/Applications

    # Bypass the /Applications path check in the main index.js
    # LM Studio verifies the app is running from /Applications and shows an
    # error dialog + refuses to auto-update if not. Replace the '/Applications'
    # string literal with '/' so that any absolute path (e.g. /nix/store/...)
    # passes the startsWith check. This works across obfuscated versions because
    # the literal string '/Applications' is stable even when variable names change.
    local indexJs="$out/Applications/LM Studio.app/Contents/Resources/app/.webpack/main/index.js"
    substituteInPlace "$indexJs" --replace-quiet "'/Applications'" "'/'"

    # Re-sign the app bundle after patching, otherwise macOS reports it as damaged
    codesign --force --deep --sign - "$out/Applications/LM Studio.app"

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
