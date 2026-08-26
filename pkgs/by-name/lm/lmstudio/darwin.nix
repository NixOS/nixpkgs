{
  stdenv,
  fetchurl,
  darwin,
  meta,
  pname,
  version,
  url,
  hash,
  passthru,
  _7zz,
}:
stdenv.mkDerivation {
  inherit meta pname version;

  src = fetchurl {
    inherit url hash;
  };

  nativeBuildInputs = [
    darwin.sigtool
    _7zz
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

    # Re-sign the main executable, otherwise macOS reports the app as damaged
    appBundle="$out/Applications/LM Studio.app"
    mainExe="$appBundle/Contents/MacOS/LM Studio"
    codesign --force --sign - "$mainExe"

    runHook postInstall
  '';

  # LM Studio ships Scripts inside the App Bundle, which may be messed up by standard fixups
  dontFixup = true;

  # undmg doesn't support APFS and 7zz does break the xattr. Took that approach from https://github.com/NixOS/nixpkgs/blob/a3c6ed7ad2649c1a55ffd94f7747e3176053b833/pkgs/by-name/in/insomnia/package.nix#L52
  # NOTE (djmaxus): even with hdiutil, a check `xattr -lr LM\ Studio.app` returns nothing,
  # meaning that xattrs are lost anyway? So, I brought back simple 7zip unpacking
  unpackPhase = ''
    7zz x -snld $src
  '';

  inherit passthru;
}
