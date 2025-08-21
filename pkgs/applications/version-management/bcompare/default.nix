{
  lib,
  acl,
  attr,
  autoPatchelfHook,
  brotli,
  bzip2,
  dbus,
  expat,
  fetchurl,
  fontconfig,
  freetype,
  glibc,
  graphite2,
  harfbuzz,
  icu,
  karchive,
  kauth,
  kcodecs,
  kcompletion,
  kconfig,
  kconfigwidgets,
  kcoreaddons,
  kcrash,
  kdbusaddons,
  keyutils,
  kguiaddons,
  ki18n,
  kiconthemes,
  kio,
  kjobwidgets,
  krb5,
  kservice,
  kwidgetsaddons,
  kwindowsystem,
  libcap,
  libffi,
  libGL,
  libpng,
  libXext,
  libxkbcommon,
  openssl,
  pcre2,
  qt5,
  qtwayland,
  runtimeShell,
  solid,
  stdenv,
  unzip,
  util-linux,
  wayland,
  xorg,
  xz,
  zlib,
  zstd,
}:

let
  pname = "bcompare";
  version = "5.1.2.31185";

  throwSystem = throw "Unsupported system: ${stdenv.hostPlatform.system}";

  srcs = {
    x86_64-linux = fetchurl {
      url = "https://www.scootersoftware.com/${pname}-${version}_amd64.deb";
      sha256 = "sha256-O03b5tpcgVWerDxTEuall+K0I61RCbEYz/OKz4juQzQ=";
    };

    x86_64-darwin = fetchurl {
      url = "https://www.scootersoftware.com/BCompareOSX-${version}.zip";
      sha256 = "sha256-jmRBwpH2UIN3zvL/LPMwcw2N2fc4IACKho8EnfYIMQg=";
    };

    aarch64-darwin = srcs.x86_64-darwin;
  };

  src = srcs.${stdenv.hostPlatform.system} or throwSystem;

  linux = stdenv.mkDerivation {
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

      # Remove libraries that refuse to be autoPatchelf'ed
      rm $out/lib/beyondcompare/ext/bcompare_ext_kde.amd64.so
      rm $out/lib/beyondcompare/ext/bcompare_ext_kde6.amd64.so

      substituteInPlace $out/bin/${pname} \
        --replace "/usr/lib/beyondcompare" "$out/lib/beyondcompare" \
        --replace "ldd" "${glibc.bin}/bin/ldd" \
        --replace "/bin/bash" "${runtimeShell}"

      # $out/bin/bcompare is already a Qt wrapper
      # Instead of creating another Qt wrapper to export QT_QPA_PLATFORM_PLUGIN_PATH,
      # just add the export to the existing one
      QT_PLUGIN_PATH="export QT_QPA_PLATFORM_PLUGIN_PATH=\"${qt5.qtbase}/${qt5.qtbase.qtPluginPrefix}/platforms\""
      sed -i "/QT_QPA_PLATFORM/a $QT_PLUGIN_PATH" "$out/bin/bcompare"
    '';

    nativeBuildInputs = [ autoPatchelfHook ];

    buildInputs = [
      (lib.getLib stdenv.cc.cc)
      acl
      attr
      brotli
      bzip2
      dbus
      expat
      fontconfig
      freetype
      graphite2
      harfbuzz
      icu
      karchive
      kauth
      kcodecs
      kcompletion
      kconfig
      kconfigwidgets
      kcoreaddons
      kcrash
      kdbusaddons
      keyutils
      kguiaddons
      ki18n
      kiconthemes
      kio
      kjobwidgets
      krb5
      kservice
      kwidgetsaddons
      kwindowsystem
      libcap
      libffi
      libGL
      libpng
      libXext
      libxkbcommon
      openssl
      pcre2
      qt5.qtbase
      qt5.qtsvg
      qt5.qtx11extras
      qtwayland
      solid
      util-linux
      wayland
      xorg.libX11
      xorg.libXau
      xorg.libxcb
      xorg.libXdmcp
      xorg.libXfixes
      xorg.xcbutilkeysyms
      xz
      zlib
      zstd
    ];

    dontBuild = true;
    dontConfigure = true;
    dontWrapQtApps = true;
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
  };

  meta = with lib; {
    description = "GUI application that allows to quickly and easily compare files and folders";
    longDescription = ''
      Beyond Compare is focused. Beyond Compare allows you to quickly and easily compare your files and folders.
      By using simple, powerful commands you can focus on the differences you're interested in and ignore those you're not.
      You can then merge the changes, synchronize your files, and generate reports for your records.
    '';
    homepage = "https://www.scootersoftware.com";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [
      ktor
      arkivm
    ];
    platforms = builtins.attrNames srcs;
    mainProgram = "bcompare";
  };
in
if stdenv.hostPlatform.isDarwin then darwin else linux
