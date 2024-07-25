{
  lib,
  stdenv,
  fetchurl,
}:

let
  versions = lib.importJSON ./versions.json;
  arch =
    if stdenv.isi686 then
      "386"
    else if stdenv.isx86_64 then
      "amd64"
    else if stdenv.isAarch32 then
      "arm"
    else if stdenv.isAarch64 then
      "arm64"
    else
      throw "Unsupported architecture";
  os =
    if stdenv.isLinux then
      "linux"
    else if stdenv.isDarwin then
      "darwin"
    else
      throw "Unsupported os";
  versionInfo = versions."${os}-${arch}";
  inherit (versionInfo) version sha256 url;

in
stdenv.mkDerivation {
  pname = "ngrok";
  inherit version;

  # run ./update
  src = fetchurl { inherit sha256 url; };

  sourceRoot = ".";

  unpackPhase = ''
    runHook preUnpack
    cp $src ngrok
    runHook postUnpack
  '';

  buildPhase = ''
    runHook preBuild
    chmod a+x ngrok
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -D ngrok $out/bin/ngrok
    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  # Stripping causes SEGFAULT on darwin
  dontStrip = stdenv.isDarwin;

  meta = {
    description = "Allows you to expose a web server running on your local machine to the internet";
    homepage = "https://ngrok.com/";
    downloadPage = "https://ngrok.com/download";
    changelog = "https://ngrok.com/docs/agent/changelog/";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      bobvanderlinden
      brodes
    ];
    mainProgram = "ngrok";
  };
}
