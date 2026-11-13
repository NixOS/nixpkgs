{
  lib,
  stdenvNoCC,
  appimageTools,
  fetchurl,
  pname,
  version,
  meta,
}:

let
  suffix =
    {
      aarch64-linux = "linux-armv7l";
      x86_64-linux = "linux-x86_64";
      i686-linux = "linux-i386";
    }
    .${stdenvNoCC.hostPlatform.system}
      or (throw "Unsupported system: ${stdenvNoCC.hostPlatform.system}");
in
appimageTools.wrapType2 (finalAttrs: {
  inherit pname version;

  src = fetchurl {
    url = "https://hamrs-releases.s3.us-east-2.amazonaws.com/${version}/hamrs-${version}-${suffix}.AppImage";
    hash =
      {
        aarch64-linux = "sha256-nBW8q7LVWQz93LkTc+c36H+2ymLLwLKfxePUwEm3D2E=";
        x86_64-linux = "sha256-tplp7TADvbxkk5qBb4c4zm4mrzrVtW/WVUjiolBBJHc=";
        i686-linux = "sha256-PllxLMBsPCedKU7OUN0nqi4qtQ57l2Z+huLfkfaBfT4=";
      }
      .${stdenvNoCC.hostPlatform.system}
        or (throw "Unsupported system: ${stdenvNoCC.hostPlatform.system}");
  };

  extraInstallCommands = ''
    install -m 444 -D ${finalAttrs.contents}/hamrs.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/hamrs.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=hamrs'
    cp -r ${finalAttrs.contents}/usr/share/icons $out/share
  '';

  inherit meta;
})
