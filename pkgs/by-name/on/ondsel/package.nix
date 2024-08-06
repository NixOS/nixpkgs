{ appimageTools, lib, stdenv, fetchurl }:

let
  pname = "ondsel";
  version = "2024.1.0";
  patch = "35694";

  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "Unsupported system: ${system}";

  suffix = {
    x86_64-linux = "Linux-x86_64.AppImage";
    # aarch64-linux = "Linux-aarch64.AppImage";
    # x86_64-darwin = "macOS-intel-x86_64.dmg";
    # aarch64-darwin = "macOS-apple-silicon-arm64.dmg";
  }.${system} or throwSystem;

  src = fetchurl {
    url = "https://github.com/Ondsel-Development/FreeCAD/releases/download/${version}/Ondsel_ES_${version}.${patch}-${suffix}";
    sha256 = {
      x86_64-linux = "sha256-UNltd0fF2MvVbmANcEaqgEBsrerxqnGCHZXMLGp6OKw=";
    }.${system} or throwSystem;
  };

  meta = with lib; {
    description = "An engineering suite with an open-source heart (Solo version)";
    homepage = "https://www.ondsel.com";
    license = licenses.lgpl2Plus;
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
    maintainers = with maintainers; [ b-eyselein ];
    mainProgram = "ondsel";
    broken = stdenv.isDarwin || (stdenv.isLinux && stdenv.isAarch64);
  };


in
appimageTools.wrapType2 rec {
  inherit pname version src meta;

  extraInstallCommands =
    let contents = appimageTools.extractType2 { inherit pname version src; };
    in ''
      mv $out/bin/ondsel-${version} $out/bin/ondsel
      install -m 444 -D ${contents}/com.ondsel.ES.desktop $out/share/applications/ondsel.desktop
      substituteInPlace $out/share/applications/ondsel.desktop \
        --replace-fail 'Exec=AppRun' 'Exec=ondsel'
      cp -r ${contents}/usr/share/icons $out/share
    '';
}

