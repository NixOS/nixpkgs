{
  lib,
  stdenv,
  callPackage,
  autoPatchelfHook,
  dpkg,
  kdePackages,
  libgcc,
  qt6,
  wrapGAppsHook3,
  requireFile,
  icu56,
}:

let
  debSystem =
    {
      x86_64-linux = "linux64";
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported system ${stdenv.hostPlatform.system}");

  deepbindShimHook = callPackage ./deepbind-shim-hook.nix { };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "fmodstudio";
  version = "2.03.12";

  src = requireFile {
    url = "https://www.fmod.com/download#fmodstudio";
    name = "fmodstudio${lib.replaceString "." "" finalAttrs.version}${debSystem}-installer.deb";
    hash = "sha256-jV1GqVqcvRMtK5zgnG4ENbpM3zGm106YfldoG4Ptq8c=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    deepbindShimHook
    dpkg
    qt6.wrapQtAppsHook
    wrapGAppsHook3
  ];

  buildInputs = [
    kdePackages.qtbase
    kdePackages.qtwebengine
    libgcc.lib
    icu56
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    for exe in fmodstudio fmodstudiocl; do
      install -Dm755 opt/fmodstudio/$exe $out/share/fmodstudio/$exe
      ln -s $out/share/fmodstudio/$exe $out/bin/$exe
    done

    install -Dm755 -t $out/lib opt/fmodstudio/lib/{libstudio.so,libfsbvorbis.so}

    cp -r -t $out/share/fmodstudio opt/fmodstudio/{Plugins,Scripts,documentation,examples,extras}

    cp -r -t $out/share usr/share/*
    substituteInPlace $out/share/applications/fmodstudio.desktop \
      --replace-fail /opt/fmodstudio/ $out/bin/

    runHook postInstall
  '';

  dontWrapGApps = true;
  deepbindShimLibraries = [
    "libfsbvorbis"
  ];

  preFixup = ''
    qtWrapperArgs+=(
      "''${gappsWrapperArgs[@]}"
      --prefix LD_LIBRARY_PATH : "$out/lib"
    )
  '';

  meta = {
    description = "Desktop application for creation of adaptive audio";
    homepage = "https://www.fmod.com";
    changelog = "https://www.fmod.com/docs/${lib.versions.majorMinor finalAttrs.version}/studio/welcome-to-fmod-studio-revision-history.html";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    mainProgram = "fmodstudio";
    maintainers = with lib.maintainers; [ ilkecan ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
