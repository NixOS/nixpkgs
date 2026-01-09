# Darwin-specific base builder.
# TODO:
#   This actually just ignores a lot of options passed to it... (e.g. buildInputs)
#   - not entirely sure how this hasn't caused big problems yet.

{
  lib,
  stdenvNoCC,
  undmg,
  ...
}:

{
  meta,
  pname,
  product,
  productShort,
  src,
  version,
  passthru,

  plugins ? [ ],
  ...
}:

let
  loname = lib.toLower productShort;
in
stdenvNoCC.mkDerivation {
  inherit
    pname
    src
    version
    plugins
    passthru
    ;
  meta = meta // {
    mainProgram = loname;
  };
  desktopName = product;
  dontFixup = true;
  installPhase = ''
    runHook preInstall
    APP_DIR="$out/Applications/${product}.app"
    mkdir -p "$APP_DIR"
    cp -Tr *.app "$APP_DIR"
    mkdir -p "$out/bin"
    cat << EOF > "$out/bin/${loname}"
    #!${stdenvNoCC.shell}
    open -na '$APP_DIR' --args "\$@"
    EOF
    chmod +x "$out/bin/${loname}"
    runHook postInstall
  '';
  nativeBuildInputs = [ undmg ];
  sourceRoot = ".";
}
