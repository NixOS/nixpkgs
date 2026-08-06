{
  lib,
  stdenvNoCC,
  fetchurl,
  undmg,
  makeWrapper,
  callPackage,
}:

let
  # Upstream / Homebrew's cask feed expose this as "<version>,<build>";
  # joined with a dash instead since commas aren't valid in Nix store names.
  version = "2.3.3-9804";
  releaseVersion = lib.head (lib.splitString "-" version);
  build = lib.last (lib.splitString "-" version);
  appNameWithMajorVersion = "Postico ${builtins.head (lib.splitString "." version)}.app";
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "postico";
  inherit version;

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchurl {
    url = "https://downloads.eggerapps.at/postico/postico-${build}.dmg";
    hash = "sha256-NH/gbP8b4dypMPNLWxMkK0VfjiK8hc+m80+Jrkg98R4=";
  };

  nativeBuildInputs = [
    undmg
    makeWrapper
  ];
  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/Applications
    cp -r "${appNameWithMajorVersion}" $out/Applications/
    runHook postInstall
  '';

  postInstall = ''
    mkdir -p $out/bin
    makeWrapper "$out/Applications/Postico 2.app/Contents/MacOS/Postico" $out/bin/${finalAttrs.pname}
  '';

  passthru.updateScript = lib.getExe (callPackage ./update.nix { });

  meta = {
    mainProgram = "postico";
    description = "A modern PostgreSQL client for macOS";
    longDescription = ''
      Postico 2 is a database app with a very strong focus on its core audience:
      people who use databases. Our customers range from researchers and analysts
      to app developers and students. Whether you want to enter data, search data,
      or perform SQL queries, Postico has you covered.
    '';
    homepage = "https://eggerapps.at/postico";
    downloadPage = "https://eggerapps.at/postico";
    changelog = "https://eggerapps.at/postico2/changelog";
    license = lib.licenses.unfree;
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    identifiers = {
      cpeParts = {
        vendor = "eggerapps";
        product = "postico";
        version = releaseVersion;
        update = build;
        target_sw = "macos";
      };
      purlParts = {
        type = "generic";
        spec = "eggerapps/postico@${version}?download_url=https://downloads.eggerapps.at/postico/postico-${build}.dmg";
      };
    };
    maintainers = with lib.maintainers; [ KristijanZic ];
  };
})
