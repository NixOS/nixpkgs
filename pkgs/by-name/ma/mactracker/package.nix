{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
  writeShellApplication,
  curl,
  cacert,
  libxml2,
  xmlstarlet,
  common-updater-scripts,
  versionCheckHook,
  writeShellScript,
  xcbuild,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "mactracker";
  version = "7.13.5";

  src = fetchurl {
    url = "https://mactracker.ca/downloads/Mactracker_${finalAttrs.version}.zip";
    hash = "sha256-VCcpEgMWo5U3BJpDSc0mQUIlmPuTKD7JBcmmKmYNf1Y=";
  };

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;
  dontUnpack = true;

  nativeBuildInputs = [ unzip ];

  sourceRoot = "Mactracker.app";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/Applications
    unzip -d $out/Applications $src -x '__MACOSX/*'
    runHook postInstall
  '';

  passthru.updateScript = lib.getExe (writeShellApplication {
    name = "mactracker-update-script";
    runtimeInputs = [
      curl
      cacert
      libxml2
      xmlstarlet
      common-updater-scripts
    ];
    text = ''
      url="https://mactracker.ca/releasenotes-mac.html"
      version=$(curl -s "$url" | xmllint -html -xmlout - | xmlstarlet sel -t -v "//faq/h5[1]")
      update-source-version mactracker "$version"
    '';
  });

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = writeShellScript "version-check" ''
    ${xcbuild}/bin/PlistBuddy -c "Print :CFBundleVersion" "$1"
  '';
  versionCheckProgramArg = [ "${placeholder "out"}/Applications/Mactracker.app/Contents/Info.plist" ];
  doInstallCheck = true;

  meta = {
    description = "Provides detailed information on every Apple Macintosh, iPod, iPhone, iPad, and Apple Watch ever made";
    homepage = "https://mactracker.ca";
    changelog = "https://mactracker.ca/releasenotes-mac.html";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ DimitarNestorov ];
    platforms = [
      "aarch64-darwin"
      "x86_64-darwin"
    ];
  };
})
