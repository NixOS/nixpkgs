{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  imagemagick,
  libicns,
  kdePackages,
  grim,
  makeBinaryWrapper,
  kdsingleapplication,
  nix-update-script,
  enableWlrSupport ? !stdenv.hostPlatform.isDarwin,
  enableMonochromeIcon ? false,
}:

assert stdenv.hostPlatform.isDarwin -> (!enableWlrSupport);

stdenv.mkDerivation (finalAttrs: {
  pname = "flameshot";
  version = "13.3.0";

  src = fetchFromGitHub {
    owner = "flameshot-org";
    repo = "flameshot";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RyoLniRmJRinLUwgmaA4RprYAVHnoPxCP9LyhHfUPe0=";
  };

  cmakeFlags = [
    "-DCMAKE_CXX_FLAGS=-I${kdsingleapplication}/include/kdsingleapplication-qt6"
    (lib.cmakeBool "USE_BUNDLED_KDSINGLEAPPLICATION" false)
    (lib.cmakeBool "DISABLE_UPDATE_CHECKER" true)
    (lib.cmakeBool "USE_MONOCHROME_ICON" enableMonochromeIcon)
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    (lib.cmakeBool "USE_WAYLAND_CLIPBOARD" true)
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    (lib.cmakeFeature "Qt6_DIR" "${kdePackages.qtbase}/lib/cmake/Qt6")
  ];

  # 1. "load-missing-deps" prevents from build inputs being fetched via GitHub.
  # 2. "macos-build" mainly patches out the use of codesigning + macdeployqt,
  #    which incorrectly fetches Qt libraries.
  # 2.1 Also fixes target link to "kdsingpleapplications-qt6" as in Nixpkgs.
  patches = [
    ./load-missing-deps.patch
    ./macos-build.patch
  ];

  nativeBuildInputs = [
    cmake
    kdePackages.qttools
    kdePackages.wrapQtAppsHook
    makeBinaryWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    imagemagick
    libicns
  ];

  buildInputs = [
    kdsingleapplication
    kdePackages.qt-color-widgets
    kdePackages.qtbase
    kdePackages.qtsvg
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    kdePackages.qtwayland # Included explicitly due to reported inconsistencies without it.
    kdePackages.kguiaddons
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    kdePackages.qhotkey
  ];

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    # Replace sips with imagemagick and iconutil with png2icns.
    sed -i -E \
      -e 's|sips -z ([0-9]+) ([0-9]+) +(.+) --out (.+)|magick \3 -resize \1x\2\\! \4|g' \
      -e 's|iconutil -o \\?"([^"]+)" -c icns \\?"([^"]+)"|png2icns \1 \2/*\{16,32,128,256,512\}.png|' \
      src/CMakeLists.txt
  '';

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir $out/Applications
    mv $out/bin/flameshot.app $out/Applications

    ln -s $out/Applications/flameshot.app/Contents/MacOS/flameshot $out/bin/flameshot

    rm -r $out/share/applications
    rm -r $out/share/dbus*
    rm -r $out/share/icons
    rm -r $out/share/metainfo
  '';

  dontWrapQtApps = true;

  postFixup =
    let
      binary =
        if stdenv.hostPlatform.isDarwin then
          "Applications/flameshot.app/Contents/MacOS/flameshot"
        else
          "bin/flameshot";
    in
    ''
      wrapProgram $out/${binary} \
        ${lib.optionalString enableWlrSupport "--prefix PATH : ${lib.makeBinPath [ grim ]}"} \
        ''${qtWrapperArgs[@]}
    '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Powerful yet simple to use screenshot software";
    homepage = "https://github.com/flameshot-org/flameshot";
    changelog = "https://github.com/flameshot-org/flameshot/releases";
    mainProgram = "flameshot";
    maintainers = with lib.maintainers; [
      scode
      oxalica
      dmkhitaryan
    ];
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
