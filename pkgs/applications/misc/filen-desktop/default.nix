{ lib
, stdenv
, fetchurl
, appimageTools
, undmg
}:

# Due to how Filen distributes releases, it is not possible to download the latest version.
# Thus, the application will always have to stay one release behind.
# https://github.com/FilenCloudDienste/filen-desktop/issues/208

let
  pname = "filen-desktop";
  version = "2.0.22";

  src = fetchurl {
    x86_64-linux = {
      url = "https://cdn.filen.io/desktop/release/v${version}/filen_x86_64.AppImage";
      hash = "sha256-Ni5pBPPZTJNO3KcHAj0JtNc/X7bqwBlIMxMTdKEwUhQ=";
    };
    x86_64-darwin = {
      url = "https://cdn.filen.io/desktop/release/v${version}/filen_x64.dmg";
      hash = "sha256-0Ql5y9+QmvZlXJZZTQC0GiBUaUIWtbhyWcl3TSutwvU=";
    };
    aarch64-linux = {
      url = "https://cdn.filen.io/desktop/release/v${version}/filen_arm64.AppImage";
      hash = "sha256-30YR2pu0c3iJiS3+bvFLpV+pCRRL1VNr8IP3DLVrAnE=";
    };
    aarch64-darwin = {
      url = "https://cdn.filen.io/desktop/release/v${version}/filen_arm64.dmg";
      hash = "sha256-3tyotK1tedgx3VlmBCJ1wz0JP8koIOgnIP7pM2XJe+g=";
    };
  }.${stdenv.system} or (throw "Unsupported system: ${stdenv.system}.");

  appimageContents = appimageTools.extractType2 { inherit pname version src; };

  linux = appimageTools.wrapType2 rec {
    inherit pname version src meta;

    extraInstallCommands = ''
      mv $out/bin/${pname}-${version} $out/bin/${pname}

      install -m 444 -D ${appimageContents}/${pname}.desktop $out/share/applications/${pname}.desktop
      substituteInPlace $out/share/applications/${pname}.desktop \
        --replace 'Exec=AppRun' 'Exec=filen-desktop'
      cp -r ${appimageContents}/usr/share/icons $out/share
    '';
  };

  darwin = stdenv.mkDerivation rec {
    inherit pname version src meta;

    nativeBuildInputs = [ undmg ];

    sourceRoot = "Filen.app";

    installPhase = ''
      mkdir -p $out/Applications/Filen.app
      cp -R . $out/Applications/Filen.app
    '';
  };

  meta = {
    description = "Desktop client for Filen.io";
    homepage = "https://filen.io/";
    license = lib.licenses.agpl3Plus;
    changelog = "https://github.com/FilenCloudDienste/filen-desktop/releases/tag/v${version}";
    maintainers = with lib.maintainers; [ taj-ny ];
    platforms = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
  };
in
if stdenv.isDarwin then darwin else linux
