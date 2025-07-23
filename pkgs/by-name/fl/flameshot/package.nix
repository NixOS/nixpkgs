{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchFromGitLab,
  fetchpatch,
  cmake,
  git,
  imagemagick,
  libicns,
  kdePackages,
  kdsingleapplication,
  grim,
  makeBinaryWrapper,
  nix-update-script,
  enableWlrSupport ? false,
  enableMonochromeIcon ? false,
}:
let
  qtColorWidgets = fetchFromGitLab {
    owner = "mattbas";
    repo = "Qt-Color-Widgets";
    rev = "352bc8f99bf2174d5724ee70623427aa31ddc26a";
    hash = "sha256-Viwk2kXUfndvylvGUyrPgb+PecZYn6iRDR22tzlRbmY=";
  };
in

assert stdenv.hostPlatform.isDarwin -> (!enableWlrSupport);

stdenv.mkDerivation {
  pname = "flameshot";
  # wlr screenshotting is currently only available on unstable version (>12.1.0)
  version = "12.1.0-unstable-2025-07-10";

  src = fetchFromGitHub {
    owner = "flameshot-org";
    repo = "flameshot";
    rev = "32e97220427e4db86ad614acb3c905f303733091";
    hash = "sha256-pMthhsIr7ZINVcv0BPID7sea1eXuQqOQvM4+BkIgte4=";

    nativeBuildInputs = [
      git
    ];

    postFetch = ''
      cd "$out"
      mkdir tmp
      cp -r "${qtColorWidgets}" tmp/qtColorWidgets
    '';
  };

  patches = [
    ./0001-NixOS-dependency-injection.patch
  ];

  cmakeFlags =
    [
      (lib.cmakeBool "DISABLE_UPDATE_CHECKER" true)
      (lib.cmakeBool "USE_MONOCHROME_ICON" enableMonochromeIcon)
      # I don't know what the hell these do
      (lib.cmakeBool "USE_KDSINGLEAPPLICATION" false)
      (lib.cmakeBool "FLAMESHOT_DEBUG_CAPTURE" false)
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      (lib.cmakeBool "USE_WAYLAND_CLIPBOARD" true)
      (lib.cmakeBool "USE_WAYLAND_GRIM" enableWlrSupport)
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      (lib.cmakeFeature "Qt6_DIR" "${kdePackages.qtbase.dev}/lib/cmake/Qt6")
    ];

  nativeBuildInputs =
    [
      cmake
      kdePackages.qttools
      kdePackages.qtsvg
      kdePackages.wrapQtAppsHook
      makeBinaryWrapper
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      imagemagick
      libicns
    ];

  buildInputs = [
    kdePackages.qtbase
    kdePackages.kguiaddons
    kdsingleapplication
  ];

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    # Fix icns generation running concurrently with png generation
    sed -E -i '/"iconutil -o/i\
        )\
        execute_process(\
    ' src/CMakeLists.txt

    # Replace unavailable commands
    sed -E -i \
        -e 's/"sips -z ([0-9]+) ([0-9]+) +(.+) --out /"magick \3 -resize \1x\2\! /' \
        -e 's/"iconutil -o (.+) -c icns (.+)"/"png2icns \1 \2\/*{16,32,128,256,512}.png"/' \
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

  passthru = {
    updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };
  };

  meta = with lib; {
    description = "Powerful yet simple to use screenshot software";
    homepage = "https://github.com/flameshot-org/flameshot";
    changelog = "https://github.com/flameshot-org/flameshot/releases";
    mainProgram = "flameshot";
    maintainers = with maintainers; [
      scode
      oxalica
    ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux ++ platforms.darwin;
  };
}
