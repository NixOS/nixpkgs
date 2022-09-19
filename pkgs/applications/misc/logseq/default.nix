{ lib, stdenv, fetchurl, appimageTools, makeWrapper, autoPatchelfHook, electron
, git, curl, expat, gcc, openssl, undmg, zlib }:
let
  inherit (stdenv.hostPlatform) system;

  throwSystem = throw "Unsupported system: ${system}";

  pname = "logseq";
  version = "0.8.5";

  meta = with lib; {
    description =
      "A local-first, non-linear, outliner notebook for organizing and sharing your personal knowledge base";
    homepage = "https://github.com/logseq/logseq";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ weihua ];
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };

  src =
    let base = "https://github.com/logseq/logseq/releases/download/${version}";
    in {
      x86_64-linux = fetchurl {
        url = "${base}/logseq-linux-x64-${version}.AppImage";
        sha256 = "sha256-1nvkjucMRAwpqg2LI+1UrICMLzSd6t0yGnYdCUNQslU=";
      };
      x86_64-darwin = fetchurl {
        url = "${base}/logseq-darwin-x64-${version}.dmg";
        sha256 = "sha256-YV4aQj1lU5EsOxumf4hU3euZkM/U4PzlC4A2X92qbnU=";
      };
    }.${system} or throwSystem;

  darwin = stdenv.mkDerivation {
    inherit pname version src meta;

    passthru.updateScript = ./update.sh;

    nativeBuildInputs = [ undmg ];

    sourceRoot = "Logseq.app";

    installPhase = ''
      runHook preInstall
      mkdir -p $out/Applications/Logseq.app
      cp -R . $out/Applications/Logseq.app
      runHook postInstall
    '';
  };

  linux = stdenv.mkDerivation rec {
    inherit pname version src meta;

    appimageContents = appimageTools.extract {
      name = "${pname}-${version}";
      inherit src;
    };

    dontUnpack = true;
    dontConfigure = true;
    dontBuild = true;

    nativeBuildInputs = [ makeWrapper autoPatchelfHook ];
    buildInputs = [ stdenv.cc.cc curl expat openssl zlib ];

    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin $out/share/${pname} $out/share/applications
      cp -a ${appimageContents}/{locales,resources} $out/share/${pname}
      cp -a ${appimageContents}/Logseq.desktop $out/share/applications/${pname}.desktop
      substituteInPlace $out/share/applications/${pname}.desktop \
        --replace Exec=Logseq Exec=${pname} \
        --replace Icon=Logseq Icon=$out/share/${pname}/resources/app/icons/logseq.png
      runHook postInstall
    '';

    postFixup = ''
      makeWrapper ${electron}/bin/electron $out/bin/${pname} \
        --prefix PATH : ${lib.makeBinPath [ git ]} \
        --add-flags $out/share/${pname}/resources/app
    '';

    passthru.updateScript = ./update.sh;

  };
in if stdenv.isDarwin then darwin else linux
