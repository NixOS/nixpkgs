{
  lib,
  stdenv,
  fetchFromGitHub,
  autoPatchelfHook,
  makeDesktopItem,
  copyDesktopItems,
  cmake,
  pkg-config,
  git,
  rustc,
  cargo,
  rustPlatform,
  catch2_3,
  ncurses,
  kdePackages,
  kissfftFloat,
  crossguid,
  reproc,
  platform-folders,
  ruby_3_3,
  alsa-lib,
  libsndfile,
  rtmidi,
  boost186,
  aubio,
  jack2,
  jack-example-tools,
  pipewire,
  supercollider-with-sc3-plugins,
  parallel,
}@args:

let
  ruby = args.ruby_3_3.withPackages (ps: [
    ps.prime
    ps.racc
    ps.rake
    ps.rexml
  ]);

  ableton-link = fetchFromGitHub {
    owner = "Ableton";
    repo = "link";
    tag = "Link-4.0";
    hash = "sha256-jbVFzb3TwNMbWogPHLtmdWEfcOxNlQmuhao4duEvNQM=";
    fetchSubmodules = true;
  };
in

stdenv.mkDerivation (finalAttrs: {
  pname = "sonic-pi";
  version = "5.0.0";

  src = fetchFromGitHub {
    owner = "sonic-pi-net";
    repo = "sonic-pi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wUW/KxL4f0ftH0euLShEhBL11/mErl+VWMoe/H2Ab+k=";
    fetchSubmodules = true;
  };

  cargoRoot = "app/external/supersonic/rust";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs)
      pname
      version
      src
      cargoRoot
      ;
    hash = "sha256-ch2og6OP9LUPAo4waL/fCD4f9oVjY2NV6MncbtnpnkI=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    autoPatchelfHook
    kdePackages.wrapQtAppsHook
    copyDesktopItems
    cmake
    pkg-config
    git
    rustc
    cargo
    rustPlatform.cargoSetupHook
    ruby
  ];

  buildInputs = [
    ncurses
    kdePackages.qtbase
    kdePackages.qtsvg
    kdePackages.qttools
    kdePackages.qtwayland
    kdePackages.qwt
    kdePackages.qscintilla
    kissfftFloat
    catch2_3
    crossguid
    reproc
    platform-folders
    ruby
    alsa-lib
    libsndfile
    jack2
    rtmidi
    boost186
    aubio
  ];

  nativeCheckInputs = [
    parallel
    supercollider-with-sc3-plugins
    jack2
  ];

  cmakeFlags = [
    "-DUSE_SYSTEM_LIBS=ON"
    "-DSUPERSONIC_SYSTEM_SNDFILE=ON"
    "-DSUPERSONIC_CARGO_OFFLINE=ON"
    "-DFETCHCONTENT_FULLY_DISCONNECTED=ON"
    "-DFETCHCONTENT_SOURCE_DIR_ABLETONLINK=/build/ableton-link"
    "-DAPP_INSTALL_ROOT=${placeholder "out"}/app"
  ];

  doCheck = true;

  # Fix shebangs on files in app and bin scripts
  postPatch = ''
    patchShebangs app bin
  '';

  preConfigure = ''
    git init
    git config user.name "Nix Build"
    git config user.email "nix@build.local"
    git add .
    git commit -m "init"

    SRC_DIR="$PWD"
    cp -r '${ableton-link}' /build/ableton-link
    chmod -R +w /build/ableton-link
    pushd /build/ableton-link
    cmake -DLINK_PATCH_DIR="$SRC_DIR/app/external/supersonic/external" -P "$SRC_DIR/app/external/supersonic/external/apply-link-patches.cmake"
    popd
    cd app
    ./linux-prebuild.sh -o
  '';

  checkPhase = ''
    runHook preCheck
  ''
  # Ruby tests
  + ''
    pushd ../server/ruby
    rake test
    popd
  ''
  # API tests, run JACK parallel to tests and quit both when one exits
  + ''
    pushd api-tests
    SONIC_PI_ENV=test parallel --no-notice -j2 --halt now,done=1 ::: 'jackd -rd dummy' 'ctest --verbose'
    popd

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall
  ''
  # Run Linux release script
  + ''
    ../linux-release.sh
  ''
  # Copy dist directory to output
  + ''
    mkdir $out
    cp -r linux_dist/* $out/
  ''
  # Copy icon
  + ''
    install -D --mode=0644 ../gui/images/icon-smaller.png $out/share/icons/hicolor/256x256/apps/sonic-pi.png

    runHook postInstall
  '';

  # $out/bin/sonic-pi is a shell script, and wrapQtAppsHook doesn't wrap them.
  dontWrapQtApps = true;
  preFixup = ''
    patchelf --shrink-rpath --allowed-rpath-prefixes "$NIX_STORE" $out/app/build/gui/sonic-pi
  ''
  # Wrap Qt GUI (distributed binary)
  + ''
    wrapQtApp $out/bin/sonic-pi \
      --prefix PATH : ${
        lib.makeBinPath [
          ruby
          supercollider-with-sc3-plugins
          jack2
          jack-example-tools
          pipewire.jack
        ]
      }
  '';

  stripDebugList = [
    "app"
    "bin"
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "sonic-pi";
      exec = "sonic-pi";
      icon = "sonic-pi";
      desktopName = "Sonic Pi";
      comment = finalAttrs.meta.description;
      categories = [
        "Audio"
        "AudioVideo"
        "Education"
      ];
    })
  ];

  passthru.updateScript = ./update.sh;

  meta = {
    homepage = "https://sonic-pi.net/";
    description = "Free live coding synth for everyone originally designed to support computing and music lessons within schools";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      Phlogistique
      kamilchm
      c0deaddict
      sohalt
    ];
    platforms = lib.platforms.linux;
  };
})
