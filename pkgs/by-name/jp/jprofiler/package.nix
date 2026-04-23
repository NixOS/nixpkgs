{
  stdenv,
  lib,
  fetchurl,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
  _7zz,
  jdk11,
}:

let
  jdk = jdk11;
  pname = "jprofiler";
  version = "14.0.5";
  nameApp = "JProfiler";

  meta = {
    description = "Java profiler for deep JVM analysis";
    longDescription = ''
      JProfiler bridges high-level analytics and low-level JVM data,
      delivering unmatched insights to solve your toughest performance
      problems, memory leaks, threading issues, and higher-level problems in
      technologies like JDBC, JPA, and more.
    '';
    homepage = "https://www.ej-technologies.com/products/jprofiler/overview.html";
    license = lib.licenses.unfree;
    maintainers = [ ];
  };

  src =
    if stdenv.hostPlatform.isLinux then
      fetchurl {
        url = "https://download.ej-technologies.com/jprofiler/jprofiler_linux_${
          lib.replaceStrings [ "." ] [ "_" ] version
        }.tar.gz";
        hash = "sha256-S7e2WurDJ0ePzpMg0YK94Mn0eHfb8/jNmf0kYts2Y0M=";
      }
    else
      fetchurl {
        url = "https://download-gcdn.ej-technologies.com/jprofiler/jprofiler_macos_${
          lib.replaceStrings [ "." ] [ "_" ] version
        }.dmg";
        hash = "sha256-HPGh+dRfLuQprpgnu8oFboHUB1xvFqPblJcowqgZ5KA=";
      };

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      exec = pname;
      icon = pname;
      comment = meta.description;
      desktopName = nameApp;
      genericName = "Java Profiler Tool";
      categories = [ "Development" ];
    })
  ];

  linux = stdenv.mkDerivation {
    inherit
      pname
      version
      src
      desktopItems
      ;

    nativeBuildInputs = [
      makeWrapper
      copyDesktopItems
    ];

    installPhase = ''
      runHook preInstall

      cp -r . $out

      rm -f $out/bin/updater
      rm -rf $out/bin/linux-ppc*
      rm -rf $out/bin/linux-armhf
      rm -rf $out/bin/linux-musl*

      for f in $(find $out/bin -type f -executable); do
        wrapProgram $f --set JAVA_HOME "${jdk.home}"
      done

      install -Dm644 "./.install4j/i4j_extf_7_1u09tly_16qtnph.png" \
        "$out/share/icons/hicolor/scalable/apps/jprofiler.png"

      runHook postInstall
    '';

    meta = meta // {
      platforms = lib.platforms.linux;
    };
  };

  darwin = stdenv.mkDerivation {
    inherit pname version src;

    nativeBuildInputs = [
      makeWrapper
      _7zz
    ];

    unpackPhase = ''
      runHook preUnpack

      7zz x $src -x!JProfiler/\[\]

      runHook postUnpack
    '';

    sourceRoot = nameApp;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/{Applications,bin}
      cp -R ${nameApp}.app $out/Applications/
      makeWrapper $out/Applications/${nameApp}.app/Contents/MacOS/JavaApplicationStub $out/bin/${pname}

      runHook postInstall
    '';

    meta = meta // {
      platforms = lib.platforms.darwin;
    };
  };
in
if stdenv.hostPlatform.isDarwin then darwin else linux
