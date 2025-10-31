{
  autoPatchelfHook,
  fetchurl,
  lib,
  makeWrapper,
  stdenv,
  writeScript,
  libGL,
  libGLU,
  libX11,
  libXext,
  libXi,
}:
stdenv.mkDerivation rec {
  pname = "defold-gdc";
  version = "1.10.1";

  src = fetchurl {
    url = "https://github.com/defold/defold/releases/download/${version}/gdc-linux";
    hash = "sha256-s67CLYoeU11ws2Mr5SjKbVhxkCLNUCA6qONU/nbuQZA=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    libXext
    libX11
    libXi
    libGL
    libGLU
  ];

  dontBuild = true;
  dontConfigure = true;
  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    install -m 755 -D $src $out/bin/defold-gdc
    runHook postInstall
  '';

  passthru = {
    updateScript = writeScript "update.sh" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p curl jq nix-update
      version=$(curl -s https://d.defold.com/editor-alpha/info.json | jq -r .version)
      nix-update defold-gdc --version "$version"
    '';
  };

  meta = {
    description = "Defold gamepad calibration tool";
    homepage = "https://defold.com/";
    license = lib.licenses.free;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ flexiondotorg ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "defold-gdc";
  };
}
