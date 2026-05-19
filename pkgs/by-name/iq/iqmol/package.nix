{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gfortran,
  pkg-config,
  boost,
  libarchive,
  libsForQt5,
  libGLU,
  libssh2,
  openbabel,
  openmesh,
  yaml-cpp,
  zlib,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "iqmol";
  version = "3.2.2";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "nutjunkie";
    repo = "IQmol3";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5W1EvUeG7VKCBoVy6J+a2CfBAaAda1spoI2B5zm1P/0=";
  };

  nativeBuildInputs = [
    cmake
    gfortran
    pkg-config
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [
    boost
    libarchive
    libsForQt5.qtbase
    libsForQt5.libqglviewer
    libGLU
    libssh2
    openbabel
    openmesh
    yaml-cpp
    zlib
  ];

  postPatch =
    let
      openbabelLibVersion = builtins.concatStringsSep "." (
        lib.take 3 (builtins.splitVersion openbabel.version)
      );
    in
    ''
      substituteInPlace CMakeLists.txt \
        --replace-fail "-static-libgcc -static-libstdc++" ""

       substituteInPlace CMakeLists.txt \
         --replace-fail "/usr/include/openbabel3" "${openbabel}/include/openbabel3" \
         --replace-fail '   ''${ARCHIVE_LIBRARY}' "   LibArchive::LibArchive"

       substituteInPlace src/Math/CMakeLists.txt \
         --replace-fail "QGLViewer" "QGLViewer-qt5"

      substituteInPlace src/Main/IQmolApplication.C \
        --replace-fail "/usr/lib/openbabel/3.1.1" "${openbabel}/lib/openbabel/${openbabelLibVersion}" \
        --replace-fail "/usr/share/openbabel" "${openbabel}/share/openbabel"

      substituteInPlace src/Util/Preferences.C \
        --replace-fail "/usr/share/iqmol" "$out/share/iqmol"
    '';

  installPhase = ''
    runHook preInstall

    install -Dm755 IQmol $out/bin/iqmol

    mkdir -p $out/share/iqmol
    cp -r $src/share/* $out/share/iqmol/

    install -Dm644 $src/doc/IQmolUserGuide.pdf $out/share/doc/iqmol/IQmolUserGuide.pdf
    install -Dm644 $src/share/man/man7/iqmol.7.gz $out/share/man/man7/iqmol.7.gz
    install -Dm644 $src/resources/IQmol.png $out/share/icons/hicolor/512x512/apps/iqmol.png
    install -Dm644 $src/resources/IQmol.appdata.xml $out/share/metainfo/iqmol.appdata.xml
    mkdir -p $out/share/applications

    substitute $src/resources/iqmol.desktop $out/share/applications/iqmol.desktop \
      --replace-fail "/usr/local/bin/iqmol" "iqmol" \
      --replace-fail "/usr/share/icons/hicolor/512x512/apps/iqmol.png" "iqmol"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A molecular builder and visualization package";
    homepage = "https://github.com/nutjunkie/IQmol3";
    changelog = "https://github.com/nutjunkie/IQmol3/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ usu171 ];
    mainProgram = "iqmol";
    platforms = lib.platforms.linux;
  };
})
