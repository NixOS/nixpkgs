{
  lib,
  autoPatchelfHook,
  bzip2,
  fetchurl,
  glibc,
  gobject-introspection,
  kdePackages,
  python3,
  stdenv,
  runtimeShell,
  unzip,
  wrapGAppsHook3,
}:

let
  pname = "bcompare";
  version = "5.2.7.32913";

  throwSystem = throw "Unsupported system: ${stdenv.hostPlatform.system}";

  srcs = {
    x86_64-linux = fetchurl {
      url = "https://www.scootersoftware.com/files/bcompare-${version}_amd64.deb";
      hash = "sha256-eIPukT6BtXe8CS5EUeaz2xOPMSJ+bt/CtYpdOs0VcfQ=";
    };

    aarch64-darwin = fetchurl {
      url = "https://www.scootersoftware.com/files/BCompareOSX-${version}.zip";
      hash = "sha256-djhYz2ZadvZEasMZQjsedoMvAXyykMJvZeZu/HE3TCc=";
    };
  };

  src = srcs.${stdenv.hostPlatform.system} or throwSystem;

  linux =
    let
      python = python3.withPackages (
        pp: with pp; [
          pygobject3
        ]
      );
    in
    stdenv.mkDerivation {
      inherit
        pname
        version
        src
        meta
        ;
      unpackPhase = ''
        ar x $src
        tar xfz data.tar.gz
      '';

      installPhase = ''
        mkdir -p $out/{bin,lib,share}

        cp -R usr/{bin,lib,share} $out/

        # Remove library that refuses to be autoPatchelf'ed
        #  - bcompare_ext_kde.amd64.so is linked with Qt4
        #  - bcompare_ext_kde5.amd64.so is linked with Qt5
        rm $out/lib/beyondcompare/ext/bcompare_ext_kde.amd64.so
        rm $out/lib/beyondcompare/ext/bcompare_ext_kde5.amd64.so

        substituteInPlace $out/bin/bcompare \
          --replace-fail "/usr/lib/beyondcompare" "$out/lib/beyondcompare" \
          --replace-fail "ldd" "${glibc.bin}/bin/ldd" \
          --replace-fail "/bin/bash" "${runtimeShell}" \
          --replace-fail "QT_QPA_PLATFORM=xcb" 'QT_QPA_PLATFORM="''${QT_QPA_PLATFORM:-wayland;xcb}"'

        substituteInPlace $out/lib/beyondcompare/bcmount.sh \
          --replace-fail "python3" "${python.interpreter}"
      '';

      postFixup = ''
        # redirect /usr/share/zoneinfo to /etc/zoneinfo (exact 19 bytes) to fix profiles hang
        sed --in-place "s|/usr/share/zoneinfo|/etc/./././zoneinfo|g" $out/lib/beyondcompare/BCompare
      '';

      nativeBuildInputs = [
        autoPatchelfHook
        gobject-introspection
        wrapGAppsHook3
      ];

      buildInputs = [
        (lib.getLib stdenv.cc.cc)
        kdePackages.kio
        kdePackages.kservice
        kdePackages.ki18n
        kdePackages.kcoreaddons
        bzip2
      ];

      dontBuild = true;
      dontConfigure = true;
      dontWrapQtApps = true;

      __structuredAttrs = true;
      strictDeps = true;
    };

  darwin = stdenv.mkDerivation {
    inherit
      pname
      version
      src
      meta
      ;
    nativeBuildInputs = [ unzip ];

    installPhase = ''
      mkdir -p $out/Applications/BCompare.app
      cp -R . $out/Applications/BCompare.app
    '';

    __structuredAttrs = true;
    strictDeps = true;
  };

  meta = {
    description = "GUI application that allows to quickly and easily compare files and folders";
    longDescription = ''
      Beyond Compare is focused. Beyond Compare allows you to quickly and easily compare your files and folders.
      By using simple, powerful commands you can focus on the differences you're interested in and ignore those you're not.
      You can then merge the changes, synchronize your files, and generate reports for your records.
    '';
    homepage = "https://www.scootersoftware.com";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      ktor
      arkivm
      barsikus007
    ];
    platforms = builtins.attrNames srcs;
    mainProgram = "bcompare";
  };
in
if stdenv.hostPlatform.isDarwin then darwin else linux
