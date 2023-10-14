{ lib, stdenv, appimageTools, fetchurl, undmg }:

let
  pname = "localsend";
  version = "1.11.1";

  hashes = {
    x86_64-linux = "sha256-K4M9cks0FNsCLIqQhSgUAz3tRMKng6JkZ/ZfwG2hZJA=";
    x86_64-darwin = "sha256-Cixo00I4BBAmUnszsz+CxPX3EY175UTufCmwQmIsEgg=";
  };

  srcs = rec {
    x86_64-linux = fetchurl {
      url = "https://github.com/localsend/localsend/releases/download/v${version}/LocalSend-${version}-linux-x86-64.AppImage";
      hash = hashes.x86_64-linux;
    };
    x86_64-darwin = fetchurl {
      url = "https://github.com/localsend/localsend/releases/download/v${version}/LocalSend-${version}.dmg";
      hash = hashes.x86_64-darwin;
    };
    aarch64-darwin = x86_64-darwin;
  };
  src = srcs.${stdenv.hostPlatform.system} or (throw "Unsupported system for package localsend: ${stdenv.hostPlatform.system}");

  appimageContents = appimageTools.extract { inherit pname version src; };

  linux = appimageTools.wrapType2 rec {
    inherit pname version src meta;

    extraPkgs = p: [ p.ayatana-ido p.libayatana-appindicator p.libayatana-indicator p.libdbusmenu p.libepoxy ];

    extraInstallCommands = ''
      mv $out/bin/${pname}-${version} $out/bin/${pname}

      install -m 444 -D ${appimageContents}/org.localsend.localsend_app.desktop \
        $out/share/applications/${pname}.desktop
      substituteInPlace $out/share/applications/${pname}.desktop \
        --replace 'Exec=localsend_app' "Exec=$out/bin/localsend"

      install -m 444 -D ${appimageContents}/localsend.png \
        $out/share/icons/hicolor/256x256/apps/localsend.png
    '';
  };

  darwin = stdenv.mkDerivation {
    inherit pname version src meta;

    nativeBuildInputs = [ undmg ];

    sourceRoot = ".";

    installPhase = ''
      mkdir -p $out/Applications
      cp -r *.app $out/Applications
    '';
  };

  meta = with lib; {
    description = "An open source cross-platform alternative to AirDrop";
    homepage = "https://localsend.org/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.mit;
    maintainers = with maintainers; [ sikmir ];
    platforms = builtins.attrNames srcs;
  };
in
if stdenv.isDarwin
then darwin
else linux
