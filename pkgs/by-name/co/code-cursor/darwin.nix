{
  stdenvNoCC,
  undmg,
  sources,
  source,
  pname,
  version,
  meta,
}:

stdenvNoCC.mkDerivation {
  inherit pname version meta;

  src = source;
  nativeBuildInputs = [ undmg ];
  dontFixup = true;
  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    APP_DIR="$out/Applications/Cursor.app"
    mkdir -p "$APP_DIR"
    cp -r . "$APP_DIR"
    mkdir -p "$out/bin"
    cat << EOF > "$out/bin/cursor"
    #!${stdenvNoCC.shell}
    open -na "$APP_DIR" --args "$@"
    EOF
    chmod +x "$out/bin/cursor"
    runHook postInstall
  '';

  passthru = {
    inherit sources;
    updateScript = ./update.sh;
  };
}
