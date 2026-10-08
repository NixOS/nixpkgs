{
  alsa-lib,
  alsa-utils,
  autoPatchelfHook,
  fetchurl,
  ffmpeg,
  lib,
  makeWrapper,
  openssl,
  stdenv,
  zlib,
}:
let
  version = "2.60.1501";
  urlVersion = builtins.replaceStrings [ "." ] [ "0" ] version;
  host = stdenv.hostPlatform.system;
  system =
    if host == "x86_64-linux" then
      "linuxx64"
    else if host == "aarch64-linux" then
      "linuxarmv8"
    else
      throw "Unsupported platform ${host}";
  src = fetchurl {
    url = "https://download.roonlabs.com/updates/production/RoonBridge_${system}_${urlVersion}.tar.bz2";
    hash =
      if system == "linuxx64" then
        "sha256-7flBDwWeHU0VPDsgV7ut+nwRv3PoJ4KxbFOXcAXE1No="
      else if system == "linuxarmv8" then
        "sha256-UbwvTQ8ted/PaUpE6deEaaSLaPl45HSslOWzXQloWKk="
      else
        throw "Unsupported platform ${host}";
  };
in
stdenv.mkDerivation {
  pname = "roon-bridge";
  inherit src version;

  dontConfigure = true;
  dontBuild = true;

  buildInputs = [
    alsa-lib
    zlib
    (lib.getLib stdenv.cc.cc)
  ];

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  installPhase =
    let
      fixBin = binPath: ''
        (
          sed -i '/ulimit/d' ${binPath}
          sed -i 's@^SCRIPT=.*@SCRIPT="$(basename "${binPath}")"@' ${binPath}
          wrapProgram ${binPath} \
            --argv0 "$(basename ${binPath})" \
            --prefix LD_LIBRARY_PATH : "${
              lib.makeLibraryPath [
                alsa-lib
                ffmpeg
                openssl
              ]
            }" \
            --prefix PATH : "${
              lib.makeBinPath [
                alsa-utils
                ffmpeg
              ]
            }"
        )
      '';
    in
    ''
      runHook preInstall
      mkdir -p $out
      mv * $out

      rm $out/check.sh
      rm $out/start.sh
      rm $out/VERSION

      ${fixBin "${placeholder "out"}/Bridge/RAATServer"}
      ${fixBin "${placeholder "out"}/Bridge/RoonBridge"}
      ${fixBin "${placeholder "out"}/Bridge/RoonBridgeHelper"}

      mkdir -p $out/bin
      makeWrapper "$out/Bridge/RoonBridge" "$out/bin/RoonBridge" --chdir "$out"

      runHook postInstall
    '';

  passthru.updateScript = ./update.py;

  meta = {
    description = "Music player for music lovers";
    changelog = "https://community.roonlabs.com/c/roon/software-release-notes/18";
    homepage = "https://roonlabs.com";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      lovesegfault
      edgarpost
    ];
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    mainProgram = "RoonBridge";
  };
}
