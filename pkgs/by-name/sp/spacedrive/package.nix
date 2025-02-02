{ lib
, pkgs
, stdenv
, fetchurl
, appimageTools
, undmg
, nix-update-script
}:

let
  pname = "spacedrive";
  version = "0.2.14";

  src = fetchurl {
    aarch64-darwin = {
      url = "https://github.com/spacedriveapp/spacedrive/releases/download/${version}/Spacedrive-darwin-aarch64.dmg";
      hash = "sha256-G0Ey7ewZeXegiqkAXFmS0MdaYllTphp7Buqs5/4/mWY=";
    };
    x86_64-darwin = {
      url = "https://github.com/spacedriveapp/spacedrive/releases/download/${version}/Spacedrive-darwin-x86_64.dmg";
      hash = "sha256-ypUDb94RlGqJfkf4htWKZ0UrGZ0SyCZrrAqtMuxDzDI=";
    };
    x86_64-linux = {
      url = "https://github.com/spacedriveapp/spacedrive/releases/download/${version}/Spacedrive-linux-x86_64.AppImage";
      hash = "sha256-DFJ1/uJW0BwEtJZxGpnvGC7U8YmsJTUbcuWEOAP2Bno=";
    };
  }.${stdenv.system} or (throw "${pname}-${version}: ${stdenv.system} is unsupported.");

  meta = {
    description = "Open source file manager, powered by a virtual distributed filesystem";
    homepage = "https://www.spacedrive.com";
    changelog = "https://github.com/spacedriveapp/spacedrive/releases/tag/${version}";
    platforms = [ "aarch64-darwin" "x86_64-darwin" "x86_64-linux" ];
    license = lib.licenses.agpl3Plus;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ DataHearth heisfer mikaelfangel stepbrobd ];
    mainProgram = "spacedrive";
  };

  passthru.updateScript = nix-update-script { };
in
if stdenv.isDarwin then stdenv.mkDerivation
{
  inherit pname version src meta passthru;

  sourceRoot = "Spacedrive.app";

  nativeBuildInputs = [ undmg ];

  installPhase = ''
    mkdir -p "$out/Applications/Spacedrive.app"
    cp -r . "$out/Applications/Spacedrive.app"
    mkdir -p "$out/bin"
    ln -s "$out/Applications/Spacedrive.app/Contents/MacOS/Spacedrive" "$out/bin/spacedrive"
  '';
}
else appimageTools.wrapType2 {
  inherit pname version src meta passthru;

  extraPkgs = pkgs: [ pkgs.libthai ];

  extraInstallCommands =
    let
      appimageContents = appimageTools.extractType2 { inherit pname version src; };
    in
    ''
      # Install .desktop files
      install -Dm444 ${appimageContents}/com.spacedrive.desktop -t $out/share/applications
      install -Dm444 ${appimageContents}/spacedrive.png -t $out/share/pixmaps
      substituteInPlace $out/share/applications/com.spacedrive.desktop \
        --replace 'Exec=usr/bin/spacedrive' 'Exec=spacedrive'
    '';
}
