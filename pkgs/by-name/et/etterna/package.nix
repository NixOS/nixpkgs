{ lib
, stdenv
, fetchFromGitHub
, writeShellScript

  # dependencies
, alsa-lib
, clang
, cmake
, curl
, libGLU
, libjack2
, libogg
, mesa
, openssl
, xorg

  # enable crash reporting. makes insecure due to dependency on python2
  # @TODO: fix crashpad; needs depot_tools
, enableCrashpad ? false
, python2
}:
let
  version = "8deab331e6c0e9b34eeeda363863193b26c221a4";

  artifacts =
    stdenv.mkDerivation (finalAttrs: {
      pname = "etterna-artifacts";
      inherit version;

      src = fetchFromGitHub {
        owner = "etternagame";
        repo = "etterna";
        rev = finalAttrs.version;
        hash = "sha256-LdJDTO8c7kS8G52b0MRO4oFhZZlcsexwJl1deVz9vf0=";
      };

      nativeBuildInputs = [
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

      cmakeFlags = lib.optionals (!enableCrashpad) [ "-D WITH_CRASHPAD=OFF" ];
    });

  wrapper = writeShellScript "etterna-wrapper" ''
    #!/usr/bin/env sh

    export ETTERNA_ROOT_DIR="$HOME/.local/share/etterna"
    export ETTERNA_ADDITIONAL_ROOT_DIRS="${artifacts}/Etterna"

    exec ${artifacts}/Etterna/Etterna "$@"
  '';
in
stdenv.mkDerivation (finalAttrs: {
  pname = "etterna";
  inherit version;

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share}

    # link artifacts
    ln -s ${artifacts}/Etterna $out/share/etterna
    ln -s ${wrapper} $out/bin/etterna

    runHook postInstall
  '';

  meta = with lib; {
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ mib ];
    mainProgram = "etterna";
  };

})
