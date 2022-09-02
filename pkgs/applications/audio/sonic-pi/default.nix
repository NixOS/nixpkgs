{ stdenv
, lib
, fetchFromGitHub
, wrapQtAppsHook
, makeDesktopItem
, copyDesktopItems
, cmake
, pkg-config
, catch2_3
, qtbase
, qtsvg
, qttools
, qwt
, qscintilla
, kissfftFloat
, crossguid
, reproc
, platform-folders
, ruby
, erlang
, elixir
, beamPackages
, alsa-lib
, rtmidi
, boost
, aubio
, jack2
, supercollider-with-sc3-plugins
, parallel

, withTauWidget ? false
, qtwebengine

, withImGui ? false
, gl3w
, SDL2
, fmt
}:

stdenv.mkDerivation rec {
  pname = "sonic-pi";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "sonic-pi-net";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-kEZNVTAWkiqxyPJHSL4Gismpwxd+PnXiH8CgQCV3+PQ=";
  };

  mixFodDeps = beamPackages.fetchMixDeps {
    inherit version;
    pname = "mix-deps-${pname}";
    mixEnv = "test";
    src = "${src}/app/server/beam/tau";
    sha256 = "sha256-MvwUyVTS23vQKLpGxz46tEVCs/OyYk5dDaBlv+kYg1M=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    wrapQtAppsHook
    copyDesktopItems
    cmake
    pkg-config
    erlang
    elixir
    beamPackages.hex
  ];

  buildInputs = [
    qtbase
    qtsvg
    qttools
    qwt
    qscintilla
    kissfftFloat
    catch2_3
    crossguid
    reproc
    platform-folders
    ruby
    alsa-lib
    rtmidi
    boost
    aubio
  ] ++ lib.optionals withTauWidget [
    qtwebengine
  ] ++ lib.optionals withImGui [
    gl3w
    SDL2
    fmt
  ];

  checkInputs = [
    parallel
    ruby
    supercollider-with-sc3-plugins
    jack2
  ];

  cmakeFlags = [
    "-DUSE_SYSTEM_LIBS=ON"
    "-DBUILD_IMGUI_INTERFACE=${if withImGui then "ON" else "OFF"}"
    "-DWITH_QT_GUI_WEBENGINE=${if withTauWidget then "ON" else "OFF"}"
  ];

  doCheck = true;

  postPatch = ''
    # Fix shebangs on files in app and bin scripts
    patchShebangs app bin
  '';

  preConfigure = ''
    # Set build environment
    export SONIC_PI_HOME="$TMPDIR/spi"

    export HEX_HOME="$TEMPDIR/hex"
    export HEX_OFFLINE=1
    export MIX_REBAR3='${beamPackages.rebar3}/bin/rebar3'
    export REBAR_GLOBAL_CONFIG_DIR="$TEMPDIR/rebar3"
    export REBAR_CACHE_DIR="$TEMPDIR/rebar3.cache"
    export MIX_HOME="$TEMPDIR/mix"
    export MIX_DEPS_PATH="$TEMPDIR/deps"
    export MIX_ENV=prod

    # Copy Mix dependency sources
    echo 'Copying ${mixFodDeps} to Mix deps'
    cp --no-preserve=mode -R '${mixFodDeps}' "$MIX_DEPS_PATH"

    # Change to project base directory
    cd app

    # Prebuild Ruby vendored dependencies and Qt docs
    ./linux-prebuild.sh -o

    # Append CMake flag depending on the value of $out
    cmakeFlags+=" -DAPP_INSTALL_ROOT=$out/app"
  '';

  postBuild = ''
    # Build BEAM server
    ../linux-post-tau-prod-release.sh -o
  '';

  checkPhase = ''
    runHook preCheck

    # BEAM tests
    pushd ../server/beam/tau
      MIX_ENV=test TAU_ENV=test mix test
    popd

    # Ruby tests
    pushd ../server/ruby
      rake test
    popd

    # API tests
    pushd api-tests
      # run JACK parallel to tests and quit both when one exits
      SONIC_PI_ENV=test parallel --no-notice -j2 --halt now,done=1 ::: 'jackd -rd dummy' 'ctest --verbose'
    popd

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    # Run Linux release script
    ../linux-release.sh

    # Copy dist directory to output
    mkdir $out
    cp -r linux_dist/* $out/

    # Copy icon
    install -Dm644 ../gui/qt/images/icon-smaller.png $out/share/icons/hicolor/256x256/apps/sonic-pi.png

    runHook postInstall
  '';

  # $out/bin/sonic-pi is a shell script, and wrapQtAppsHook doesn't wrap them.
  dontWrapQtApps = true;
  preFixup = ''
    # Wrap Qt GUI (distributed binary)
    wrapQtApp $out/bin/sonic-pi \
      --prefix PATH : ${lib.makeBinPath [ ruby supercollider-with-sc3-plugins jack2 ]}

    # If ImGui was built
    if [ -e $out/app/build/gui/imgui/sonic-pi-imgui ]; then
      # Wrap ImGui into bin
      makeWrapper $out/app/build/gui/imgui/sonic-pi-imgui $out/bin/sonic-pi-imgui \
        --inherit-argv0 \
        --prefix PATH : ${lib.makeBinPath [ ruby supercollider-with-sc3-plugins jack2 ]}
    fi

    # Remove runtime Erlang references
    for file in $(grep -FrIl '${erlang}/lib/erlang' $out/app/server/beam/tau); do
      substituteInPlace "$file" --replace '${erlang}/lib/erlang' $out/app/server/beam/tau/_build/prod/rel/tau
    done
  '';

  stripDebugList = [ "app" "bin" ];

  desktopItems = [
    (makeDesktopItem {
      name = "sonic-pi";
      exec = "sonic-pi";
      icon = "sonic-pi";
      desktopName = "Sonic Pi";
      comment = meta.description;
      categories = [ "Audio" "AudioVideo" "Education" ];
    })
  ];

  meta = with lib; {
    homepage = "https://sonic-pi.net/";
    description = "Free live coding synth for everyone originally designed to support computing and music lessons within schools";
    license = licenses.mit;
    maintainers = with maintainers; [ Phlogistique kamilchm c0deaddict sohalt lilyinstarlight ];
    platforms = platforms.linux;
  };
}
