{
  appimageTools,
  lib,
  fetchurl,
  stdenv,
}:

let
  suffix =
    {
      aarch64-linux = "linux-armv7l";
      x86_64-linux = "linux-x86_64";
      i686-linux = "linux-i386";
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
in
appimageTools.wrapType2 rec {
  pname = "hamrs";
  version = "1.0.7";

  src = fetchurl {
    url = "https://hamrs-releases.s3.us-east-2.amazonaws.com/${version}/hamrs-${version}-${suffix}.AppImage";
    hash =
      {
        aarch64-linux = "sha256-nBW8q7LVWQz93LkTc+c36H+2ymLLwLKfxePUwEm3D2E=";
        x86_64-linux = "sha256-tplp7TADvbxkk5qBb4c4zm4mrzrVtW/WVUjiolBBJHc=";
        i686-linux = "sha256-PllxLMBsPCedKU7OUN0nqi4qtQ57l2Z+huLfkfaBfT4=";
      }
      .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  };

  extraInstallCommands =
    let
      contents = appimageTools.extract { inherit pname version src; };
    in
    ''
      install -m 444 -D ${contents}/${pname}.desktop -t $out/share/applications
      substituteInPlace $out/share/applications/${pname}.desktop \
        --replace-fail 'Exec=AppRun' 'Exec=${pname}'
      cp -r ${contents}/usr/share/icons $out/share
    '';

  meta = with lib; {
    description = "A simple, portable logger tailored for activities like Parks on the Air, Field Day, and more.";
    homepage = "https://hamrs.app/";
    license = licenses.unfree;
    maintainers = [ maintainers.jhollowe ];
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
      "i686-linux"
    ];
    mainProgram = "hamrs";
    sourceProvenance = [ sourceTypes.binaryNativeCode ];
  };
}
