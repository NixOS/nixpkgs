{ ant, copyDesktopItems, dfu-util, fetchpatch, fetchurl, fetchFromGitHub
, gcc-arm-embedded-6, lib, makeDesktopItem, makeWrapper, nix-update-script
, stdenv, pkg-config, systemd, unzip, zulu }:
let
  ksolotiVersion = "1.0.12-8";
  libusbVersion = "1.0.19";
  chibiOSVersion = "2.6.9";
  inherit (lib) licenses maintainers;

  src = fetchFromGitHub {
    owner = "ksoloti";
    repo = "ksoloti";
    rev = ksolotiVersion;
    sha256 = "sha256-UYxCnEZORpfhaHSl6YohuFiQLPoQ1oyJUL9W6Maf8AE=";
  };

  libusb = stdenv.mkDerivation (finalAttrs: {
    name = "libusb";
    version = libusbVersion;
    src = let
      minorVersion = builtins.concatStringsSep "."
        (lib.take 2 (builtins.splitVersion finalAttrs.version));
    in fetchurl {
      url =
        "https://sourceforge.net/projects/libusb/files/libusb-${minorVersion}/libusb-${finalAttrs.version}/libusb-${finalAttrs.version}.tar.bz2";
      sha256 = "sha256-bFAsgWAC+Q1PdgUKZCnDp+DYQgQiLL/y3Old13O6aEA=";
    };

    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ systemd ];

    patches = [
      (fetchpatch {
        url =
          "https://raw.githubusercontent.com/ksoloti/ksoloti/${ksolotiVersion}/platform_linux/src/libusb.stdfu.patch";
        sha256 = "sha256-bYzcE20fnwBTZUZmYYHgkW7SekO6pgoj6AaTGIw8kqQ=";
      })
    ];
  });

  patched-dfu-util = dfu-util.overrideAttrs (oldAttrs: {
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ libusb ];
  });

  chibios = stdenv.mkDerivation {
    name = "chibios";
    version = chibiOSVersion;
    src = fetchFromGitHub {
      owner = "ChibiOS";
      repo = "ChibiOS";
      rev = "ver${chibiOSVersion}";
      hash = "sha256-ILb6OluhriztSRbVIqb4NGzmbSlH9cb+NOw3b58Hz0I=";
    };

    nativeBuildInputs = [ unzip ];

    patchPhase = ''
      runHook prePatch

      cd ext
      unzip -o fatfs-0.9-patched.zip
      cd ..

      runHook postPatch
    '';

    dontBuild = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -r * $out

      runHook postInstall
    '';
  };

  ksoloti-firmware = stdenv.mkDerivation {
    name = "ksoloti-firmware";
    inherit src;
    buildInputs = [ chibios ];
    nativeBuildInputs = [ patched-dfu-util gcc-arm-embedded-6 ];

    patchPhase = ''
      runHook prePatch

      ln -sf ${chibios} ./chibios

      runHook postPatch
    '';

    buildPhase = ''
      runHook preBuild

      export axoloti_release=$(pwd)

      for build_dir in firmware{,_axoloti_legacy}/{,flasher/flasher_,mounter/mounter_}build; do
        mkdir -p $axoloti_release/$build_dir/{obj,lst}
        cd $axoloti_release/$(dirname $build_dir)
        make
      done

      cd $axoloti_release

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -r firmware{,_axoloti_legacy} $out

      runHook postInstall
    '';
  };
in stdenv.mkDerivation rec {
  pname = "ksoloti";
  version = ksolotiVersion;

  inherit src;

  passthru = { updateScript = nix-update-script { }; };

  buildInputs = [ ksoloti-firmware chibios zulu ant ];
  nativeBuildInputs = [ makeWrapper copyDesktopItems ];

  buildPhase = ''
    runHook preBuild

    ant -Dbuild.version=${version} -Dshort.version=${
      builtins.head (builtins.split "-" version)
    }

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    chmod +x Ksoloti.sh
    mkdir -p $out/opt/ksoloti
    cp -r * $out/opt/ksoloti
    rm -r $out/opt/ksoloti/firmware{,_axoloti_legacy}
    ln -sf ${chibios} $out/opt/ksoloti/chibios

    wrapProgram "$out/opt/ksoloti/Ksoloti.sh" \
      --prefix PATH : '${lib.makeBinPath [ zulu gcc-arm-embedded-6 ]}' \
      --prefix LD_LIBRARY_PATH : '${
        lib.makeLibraryPath [ gcc-arm-embedded-6 ]
      }' \
      --set JAVA_HOME '${zulu}' \
      --set axoloti_release $out/opt/ksoloti \
      --set axoloti_firmware ${ksoloti-firmware}/firmware \
      --set axoloti_home AXOLOTI_HOME

    substituteInPlace $out/opt/ksoloti/Ksoloti.sh --replace-fail "'AXOLOTI_HOME'" '"''${XDG_DATA_HOME:-$HOME/.local/share}/ksoloti"'
    mkdir -p $out/bin
    ln -s $out/opt/ksoloti/Ksoloti.sh $out/bin/ksoloti

    install -Dm444 platform_linux/49-axoloti.rules -t $out/lib/udev/rules.d
    install -Dm444 src/main/java/resources/ksoloti_icon_256.png $out/share/pixmaps/ksoloti.png

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "Ksoloti";
      exec = "ksoloti";
      icon = "ksoloti";
      desktopName = "Ksoloti";
      comment = meta.description;
      categories = [ "Audio" "AudioVideo" ];
      startupWMClass = "ksoloti";
    })
  ];

  meta = {
    description = "A program to create sound patches for Ksoloti Core";
    homepage = "https://ksoloti.github.io";
    license = licenses.gpl3;
    maintainers = [ maintainers.repomaa ];
    mainProgram = "ksoloti";
  };
}
