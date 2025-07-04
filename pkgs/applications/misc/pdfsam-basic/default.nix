{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  wrapGAppsHook3,
  desktop-file-utils,
  temurin-jre-bin-21, # use jdk21 will cause java.lang.NoSuchMethodError: 'javafx.application.Platform$Preferences javafx.application.Platform.getPreferences()'
  javaPackages,
  xorg,
  gtk3,
  libGL,
  alsa-lib,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pdfsam-basic";
  version = "5.3.1";

  src = fetchurl {
    url = "https://github.com/torakiki/pdfsam/releases/download/v${finalAttrs.version}/pdfsam-basic_${finalAttrs.version}-1_amd64.deb";
    hash = "sha256-Fhj/MJnnm8nsuJmSb6PigJT6Qm+CkGg8lV0NaUMfur0=";
  };

  nativeBuildInputs = [
    dpkg
    wrapGAppsHook3
    desktop-file-utils
  ];

  installPhase = ''
    runHook preInstall

    desktop-file-edit usr/share/applications/pdfsam-basic.desktop \
      --set-key="Exec" --set-value="pdfsam-basic %F" \
      --set-key="Path" --set-value="$out/share/pdfsam-basic" \
      --set-icon="pdfsam-basic"
    mkdir $out
    cp -r usr/share $out/share
    mkdir $out/share/pdfsam-basic
    cp -r opt/pdfsam-basic/lib $out/share/pdfsam-basic/lib
    install -Dm0644 opt/pdfsam-basic/splash.png $out/share/pdfsam-basic/splash.png
    install -Dm0644 opt/pdfsam-basic/icon.svg $out/share/icons/hicolor/scalable/apps/pdfsam-basic.svg
    mkdir $out/bin
    makeWrapper ${temurin-jre-bin-21}/bin/java $out/bin/pdfsam-basic \
      "''${gappsWrapperArgs[@]}" \
      --set JAVA_HOME ${temurin-jre-bin-21} \
      --set PDFSAM_JAVA_PATH ${temurin-jre-bin-21} \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          javaPackages.openjfx21
          xorg.libXxf86vm
          xorg.libXtst
          gtk3
          libGL
          alsa-lib
        ]
      } \
      --add-flags ${
        lib.escapeShellArg (
          lib.escapeShellArgs [
            "--enable-preview"
            "--module-path"
            "${placeholder "out"}/share/pdfsam-basic/lib"
            "--module"
            "org.pdfsam.basic/org.pdfsam.basic.App"
            "-Xmx512M"
            "-splash:${placeholder "out"}/share/pdfsam-basic/splash.png"
            "-Dapp.name=\"pdfsam-basic\""
            "-Dapp.pid=\"$$\""
            "-Dapp.home=\"${placeholder "out"}/share/pdfsam-basic\""
            "-Dbasedir=\"${placeholder "out"}/share/pdfsam-basic\""
            "-Dprism.lcdtext=false"
          ]
        )
      }

    runHook postInstall
  '';

  dontWrapGApps = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/torakiki/pdfsam";
    description = "Multi-platform software designed to extract pages, split, merge, mix and rotate PDF files";
    mainProgram = "pdfsam-basic";
    sourceProvenance = with lib.sourceTypes; [
      binaryBytecode
      binaryNativeCode
    ];
    license = lib.licenses.agpl3Plus;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ _1000101 ];
  };
})
