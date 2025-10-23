{
  lib,
  stdenv,
  fetchFromGitHub,
  kdePackages,
  qt6,
  cmake,
  libqalculate,
  muparser,
  libarchive,
  python3Packages,
  nix-update-script,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "albert";
  version = "33.0.1";

  src = fetchFromGitHub {
    owner = "albertlauncher";
    repo = "albert";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zHLyvFzLR7Ryk6eoD+Lp+w4bIj7MAeREK0YzRXYnx6c=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    kdePackages.qtkeychain
    libqalculate
    libarchive
    muparser
  ]
  ++ (with qt6; [
    qt5compat
    qtbase
    qtdeclarative
    qtscxml
    qtsvg
    qttools
    qtwayland
  ])
  ++ (with python3Packages; [
    python
    pybind11
  ]);

  postPatch = ''
    find -type f -name CMakeLists.txt -exec sed -i {} -e '/INSTALL_RPATH/d' \;

    substituteInPlace src/app/qtpluginprovider.cpp \
      --replace-fail "QStringList install_paths;" "QStringList install_paths;${"\n"}install_paths << QFileInfo(\"$out/lib\").canonicalFilePath();"
  '';

  postFixup = ''
    for i in $out/{bin/.albert-wrapped,lib/albert/plugins/*.so}; do
      patchelf $i --add-rpath $out/lib/albert
    done
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Fast and flexible keyboard launcher";
    longDescription = ''
      Albert is a desktop agnostic launcher. Its goals are usability and beauty,
      performance and extensibility. It is written in C++ and based on the Qt
      framework.
    '';
    homepage = "https://albertlauncher.github.io";
    changelog = "https://github.com/albertlauncher/albert/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    # See: https://github.com/NixOS/nixpkgs/issues/279226
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      synthetica
      eljamm
    ];
    mainProgram = "albert";
    platforms = lib.platforms.linux;
  };
})
