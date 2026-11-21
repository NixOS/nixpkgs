{
  lib,
  stdenv,
  fetchzip,
  autoPatchelfHook,
  makeWrapper,
  versionCheckHook,
  replaceVars,
  file,
  gtk3,
  glib,
  gdk-pixbuf,
  libx11,
  libxcursor,
  fontconfig,
  freetype,
  pango,
  libxrender,
  cairo,
  zlib,
  libxml2_13,
  nss,
  nspr,
  libGL,
  jre,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "air-sdk";
  version = "51.3.1.2";

  src = fetchzip {
    name = "AIRSDK_Linux";
    url = "https://airsdk.harman.com/api/versions/${finalAttrs.version}/sdks/AIRSDK_Linux.zip?license=accepted";
    extension = "zip";
    stripRoot = false;
    hash = "sha256-BeDvdI4t960EFwMlOTQMIVd4vbEI9Ibm2S2/bCA/gj0=";
  };

  nativeBuildInputs = [
    file
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    gtk3
    glib
    stdenv.cc.cc
    gdk-pixbuf
    libx11
    libxcursor
    fontconfig
    freetype
    pango
    libxrender
    cairo
    zlib
    libxml2_13
    nss
    nspr
    libGL
  ];

  postPatch = ''
    patchShebangs bin/configure_linux.sh
  '';

  buildPhase = ''
    runHook preBuild

    bin/configure_linux.sh ${if stdenv.hostPlatform.isx86 then "x86_64" else "arm64"}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    phome=$out/share/AIRSDK
    mkdir -p $phome
    cp -r * $phome

    mkdir -p $out/bin
    for bin in aasdoc acompc adl adt amxmlc asdoc compc fdb fontswf mxmlc optimizer swcdepends swfcompress swfdump swfencrypt; do
      if [[ $(file -b --mime-encoding $phome/bin/$bin) != binary ]]; then
        sed -i '1{/^#!/!i #!/bin/sh
      }' $phome/bin/$bin
      fi
      chmod +x $phome/bin/$bin
      wrapProgram $phome/bin/$bin --prefix PATH : ${lib.makeBinPath [ jre ]} --inherit-argv0
      ln -s $phome/bin/$bin $out/bin/$bin
    done

    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckKeepEnvironment = [ "PATH" ];
  doInstallCheck = true;
  versionCheckProgramArg = "-version";

  setupHook = ./setup-hook.sh;

  passthru = {
    sdk = "${finalAttrs.finalPackage}/share/AIRSDK";
    runtime = "${finalAttrs.finalPackage}/share/AIRSDK";
    updateScript = ./update.sh;
  };

  meta = {
    description = "SDK to build AIR applications with ActionScript 3.0 using Adobe Flex and Adobe Flash";
    homepage = "https://airsdk.harman.com";
    downloadPage = "https://airsdk.harman.com/download";
    changelog = "https://airsdk.harman.com/release_notes";
    license = lib.licenses.unfreeRedistributable;
    maintainers = with lib.maintainers; [ ulysseszhan ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    mainProgram = "adt";
  };
})
