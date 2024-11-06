{
  lib,
  stdenv,
  fetchFromGitHub,
  writeShellScript,

  # dependencies
  alsa-lib,
  clang,
  cmake,
  curl,
  libGLU,
  libjack2,
  libogg,
  mesa,
  openssl,
  xorg,

  # enable crash reporting. makes insecure due to dependency on python2
  # @TODO: fix crashpad; needs depot_tools
  enableCrashpad ? false,
  python2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "etterna";
  version = "8deab331e6c0e9b34eeeda363863193b26c221a4";

  src = fetchFromGitHub {
    owner = "etternagame";
    repo = "etterna";
    rev = finalAttrs.version;
    hash = "sha256-LdJDTO8c7kS8G52b0MRO4oFhZZlcsexwJl1deVz9vf0=";
  };

  nativeBuildInputs =
    [
      alsa-lib
      clang
      cmake
      curl
      libGLU
      libjack2
      libogg
      mesa
      openssl
      xorg.libX11
      xorg.libXext
      xorg.libXrandr
    ]
    # crashpad relies on python2 and depot_tools
    ++ lib.optionals enableCrashpad [ python2 ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share/etterna}

    # copy select necessary game files into virtual fs
    for dir in \
      Announcers Assets BGAnimations \
      BackgroundEffects BackgroundTransitions \
      Data GameTools NoteSkins Scripts \
      Songs Themes
    do
      cp -r "/build/source/$dir" "$out/share/etterna/$dir"
    done

    # copy binary
    cp /build/source/Etterna $out/bin/etterna-unwrapped

    # wacky insertion of wrapper directly into phase, so that $out is set
    cat > $out/bin/etterna << EOF
      #!${stdenv.shell}

      export ETTERNA_ROOT_DIR="\$HOME/.local/share/etterna"
      export ETTERNA_ADDITIONAL_ROOT_DIRS="$out/share/etterna"

      echo "HOME: \$HOME"
      echo "PWD: \$(pwd)"
      echo "ETTERNA_ADDITIONAL_ROOT_DIRS: \$ETTERNA_ADDITIONAL_ROOT_DIRS"

      exec $out/bin/etterna-unwrapped "\$@"
    EOF

    chmod +x $out/bin/etterna

    runHook postInstall
  '';

  cmakeFlags = lib.optionals (!enableCrashpad) [ "-D WITH_CRASHPAD=OFF" ];

  meta = with lib; {
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ mib ];
    mainProgram = "etterna";
  };
})
