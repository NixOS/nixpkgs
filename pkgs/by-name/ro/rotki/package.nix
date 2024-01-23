{ lib
, stdenv
, fetchurl
, appimageTools
, libsecret
, libxshmfence
, undmg
}:
let
  # special thanks to FlorianFranzen
  pname = "rotki";
  version = "1.31.2";

  src = {
    x86_64-linux = fetchurl {
      url = "https://github.com/rotki/rotki/releases/download/v${version}/rotki-linux_x86_64-v${version}.AppImage";
      hash = "sha256-4BMNYsqyr8/yFFoU5zY2ttf4wN4hJc6fF9fpuXIcbQ0=";
    };
    aarch64-darwin = fetchurl {
      url = "https://github.com/rotki/rotki/releases/download/v${version}/rotki-darwin_arm64-v${version}.dmg";
      hash = "sha256-R/HG/Nf99clnLOW53mEncxU+sXHlAjXI8Qy2A+Ie/w4=";
    };
  }.${stdenv.system} or (throw "${pname} ${version}: unsupported system ${stdenv.system}");

  meta = with lib; {
    homepage = "https://www.rotki.com/";
    downloadPage = "https://rotki.com/download";
    description = "The portfolio manager that protects your privacy.";
    longDescription = ''
      Rotki is an open source portfolio tracker, accounting and analytics tool that protects your privacy.
    '';
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ adamjedrzejewski ];
    platforms = [ "x86_64-linux" "aarch64-darwin" ];
    mainProgram = pname;
  };

  appimageContents = appimageTools.extract { inherit pname src version; };
in
if stdenv.isLinux
then appimageTools.wrapType2 {
  inherit pname src meta version;

  extraPkgs = pkgs: [
    libsecret
    libxshmfence
  ];

  extraInstallCommands = ''
    mv $out/bin/{${pname}-${version},${pname}}
    install -Dm644 ${appimageContents}/rotki.desktop -t $out/share/applications
    install -Dm644 ${appimageContents}/rotki.png -t $out/share/icons/hicolor/256x256/apps
    substituteInPlace $out/share/applications/rotki.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
  '';
}
else stdenv.mkDerivation {
    inherit pname version src meta;

    nativeBuildInputs = [ undmg ];

    sourceRoot = ".";

    installPhase = ''
      mkdir -p $out/Applications
      cp -r *.app $out/Applications
    '';
}
