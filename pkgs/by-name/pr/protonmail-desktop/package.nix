{ lib
, mkYarnPackage
, fetchurl
, makeWrapper
, zip
, unzip
, git
, stdenv
, linkFarm
}: let
  electron = {
    build = fetchurl {
      url = "https://github.com/electron/electron/releases/download/v${electron.version}/electron-v${electron.version}-linux-x64.zip";
      sha256 = "sha256-cVj/KmkLOGumZePcbedB8MjnJAihbF6eo3Th3BEb8EI=";
    };
    version = "29.0.1";
    zip = linkFarm "electron-zip-dir" [
      {
        name = "${electron.build.name}";
        path = electron.build;
      }
    ];
  };

  src = stdenv.mkDerivation {
    pname = "pmd-source";
    inherit version;

    src = fetchurl {
      url = "https://github.com/ProtonMail/inbox-desktop/releases/download/v${version}/desktop-release-${version}.zip";
      hash = "sha256-VVpX1gfPUIQKGkA6Eg9krJKvL8H8h+9TsctrSm5se5k=";
    };

    nativeBuildInputs = [ unzip ];

    dontUnpack = true;
    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      unzip -d $out $src
      cp ${./forge.config.ts} $out
    '';
  };

  mainProgram = "proton-mail";
  version = "1.0.2";

in mkYarnPackage {
  pname = "protonmail-desktop";
  inherit version src;

  nativeBuildInputs = [
    git
    zip
  ];

  env = {
    DEBUG = "*";
    ELECTRON_SKIP_BINARY_DOWNLOAD = 1;
    electron_zip_dir = electron.zip;
  };

  buildPhase = ''
    # set -x

    pushd deps/proton-mail
    rm proton-mail

    # substituteInPlace forge.config.ts \
    #   --replace-fail "@ELECTRON_ZIP@" "${electron.zip}"

    popd

    export HOME=$(mktemp -d)
    # ./node_modules/.bin/electron-forge package -a x64 -p linux
    yarn --offline run package -a x64 -p linux
  '';

  /*preFixup = ''
    makeWrapper ${lib.getExe electron} $out/bin/${mainProgram} \
      --add-flags $out/share/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
      --set-default ELECTRON_FORCE_IS_PACKAGED 1 \
      --set-default ELECTRON_IS_DEV 0 \
      --inherit-argv0
  '';*/

  meta = {
    description = "Desktop application for Mail and Calendar, made with Electron";
    homepage = "https://github.com/ProtonMail/inbox-desktop";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ rsniezek sebtm ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    inherit mainProgram;
  };
}

