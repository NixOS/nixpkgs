{ lib
, stdenvNoCC
, undmg
, ...
}:

{ meta
, pname
, product
, productShort ? product
, src
, version
<<<<<<< HEAD
, plugins ? [ ]
, buildNumber
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, ...
}:

let
  loname = lib.toLower productShort;
in
<<<<<<< HEAD
stdenvNoCC.mkDerivation {
  inherit pname meta src version plugins;
  passthru.buildNumber = buildNumber;
  desktopName = product;
  installPhase = ''
    runHook preInstall
    APP_DIR="$out/Applications/${product}.app"
    mkdir -p "$APP_DIR"
    cp -Tr "${product}.app" "$APP_DIR"
    mkdir -p "$out/bin"
    cat << EOF > "$out/bin/${loname}"
    open -na '$APP_DIR' --args "\$@"
    EOF
    chmod +x "$out/bin/${loname}"
    runHook postInstall
  '';
  nativeBuildInputs = [ undmg ];
  sourceRoot = ".";
}
=======
  stdenvNoCC.mkDerivation {
    inherit pname meta src version;
    desktopName = product;
    installPhase = ''
      runHook preInstall
      APP_DIR="$out/Applications/${product}.app"
      mkdir -p "$APP_DIR"
      cp -Tr "${product}.app" "$APP_DIR"
      mkdir -p "$out/bin"
      cat << EOF > "$out/bin/${loname}"
      open -na '$APP_DIR' --args "\$@"
      EOF
      chmod +x "$out/bin/${loname}"
      runHook postInstall
    '';
    nativeBuildInputs = [ undmg ];
    sourceRoot = ".";
  }
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
