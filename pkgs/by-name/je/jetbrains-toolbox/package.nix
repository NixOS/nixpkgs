{
  lib,
  stdenv,
  appimageTools,
  fetchzip,
  fetchurl,
  makeWrapper,
  icu,
  libappindicator-gtk3,
  undmg,
}:

let
  pname = "jetbrains-toolbox";
  version = "2.6.1.40902";

  updateScript = ./update.sh;

  meta = {
    description = "Jetbrains Toolbox";
    homepage = "https://jetbrains.com/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ AnatolyPopov ];
    platforms = [
      "aarch64-linux"
      "aarch64-darwin"
      "x86_64-linux"
      "x86_64-darwin"
    ];
    mainProgram = "jetbrains-toolbox";
  };

  selectSystem =
    attrs:
    attrs.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  linux = appimageTools.wrapAppImage rec {
    inherit pname version meta;

    source =
      let
        arch = selectSystem {
          x86_64-linux = "";
          aarch64-linux = "-arm64";
        };
      in
      fetchzip {
        url = "https://download.jetbrains.com/toolbox/jetbrains-toolbox-${version}${arch}.tar.gz";
        hash = selectSystem {
          x86_64-linux = "sha256-P4kv6ca6mGtl334HKNkdo9Iib/Cgu3ROrbQKlQqxUj4=";
          aarch64-linux = "sha256-mG8GAVPi2I0A13rKhXoXxiRIHK1QOWPv4gZxfm0+DKs=";
        };
      };

    src = appimageTools.extractType2 {
      inherit pname version;
      src = source + "/jetbrains-toolbox";
      postExtract = ''
        patchelf --add-rpath ${lib.makeLibraryPath [ icu ]} $out/jetbrains-toolbox
      '';
    };

    nativeBuildInputs = [ makeWrapper ];

    extraInstallCommands = ''
      install -Dm644 ${src}/jetbrains-toolbox.desktop $out/share/applications/jetbrains-toolbox.desktop
      install -Dm644 ${src}/.DirIcon $out/share/icons/hicolor/scalable/apps/jetbrains-toolbox.svg
      wrapProgram $out/bin/jetbrains-toolbox \
        --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libappindicator-gtk3 ]} \
        --append-flags "--update-failed"
    '';

    passthru = {
      src = source;
      inherit updateScript;
    };
  };

  darwin = stdenv.mkDerivation (finalAttrs: {
    inherit pname version meta;

    src =
      let
        arch = selectSystem {
          x86_64-darwin = "";
          aarch64-darwin = "-arm64";
        };
      in
      fetchurl {
        url = "https://download.jetbrains.com/toolbox/jetbrains-toolbox-${finalAttrs.version}${arch}.dmg";
        hash = selectSystem {
          x86_64-darwin = "sha256-Dw1CqthgvKIlHrcQIoOpYbAG5c6uvq/UgzaO4n25YJY=";
          aarch64-darwin = "sha256-b/z8Pq8h6n34junSMyxRS3Y/TQ3tu05Bh77xlvMvEtI=";
        };
      };

    nativeBuildInputs = [ undmg ];

    sourceRoot = "JetBrains Toolbox.app";

    installPhase = ''
      runHook preInstall

      mkdir -p $out/Applications $out/bin
      cp -r . $out/Applications/"JetBrains Toolbox.app"
      ln -s $out/Applications/"JetBrains Toolbox.app"/Contents/MacOS/jetbrains-toolbox $out/bin/jetbrains-toolbox

      runHook postInstall
    '';

    passthru = {
      inherit updateScript;
    };
  });
in
if stdenv.hostPlatform.isDarwin then darwin else linux
