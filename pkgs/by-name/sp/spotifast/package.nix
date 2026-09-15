{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  cmake,
  makeWrapper,
  writeShellScript,
  dbus,
  alsa-lib,
  libpulseaudio,
  libGL,
  libx11,
  libxkbcommon,
  wayland,
  libxcursor,
  libxi,
  libxrandr,
  apple-sdk_15,
}:

let
  # projectm-sys expects CMake to install into lib/, while CMake defaults to
  # lib64/ on NixOS. Wrap cmake to force it, matching upstream's flake.nix.
  cmakeWithLibdir = writeShellScript "cmake-spotifast" ''
    if [[ "$1" == "--build" ]]; then
      exec ${cmake}/bin/cmake "$@"
    else
      exec ${cmake}/bin/cmake "$@" -DCMAKE_INSTALL_LIBDIR=lib
    fi
  '';
in
rustPlatform.buildRustPackage rec {
  pname = "spotifast";
  version = "0.8.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "crmne";
    repo = "spotifast";
    tag = "v${version}";
    hash = "sha256-cX9DXG4u7mBSl6sO768A1vJ9kHZZc12+STzRU0KuWh0=";
  };

  cargoHash = "sha256-A17V9f8cueyYaX/aIPMTTYERGSxNbSJrd0bpwDZXUyI=";

  nativeBuildInputs = [
    pkg-config
    cmake
    rustPlatform.bindgenHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ makeWrapper ];

  nativeCheckInputs = lib.optionals stdenv.hostPlatform.isLinux [ dbus ];

  buildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [
      alsa-lib
      libpulseaudio
      libGL
      libx11
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ apple-sdk_15 ];

  env.CMAKE = "${cmakeWithLibdir}";

  # The GUI dlopens its Wayland, X11 and GL libraries at run time.
  # Both the spotifast binary and the fastpotify compatibility binary need it.
  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    for bin in spotifast fastpotify; do
      wrapProgram $out/bin/$bin \
        --prefix LD_LIBRARY_PATH : ${
          lib.makeLibraryPath [
            libxkbcommon
            wayland
            libGL
            libx11
            libxcursor
            libxi
            libxrandr
          ]
        }
    done
  '';

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    install -Dm644 packaging/applications/fastpotify.desktop \
      $out/share/applications/fastpotify.desktop
    install -Dm644 packaging/icons/fastpotify.svg \
      $out/share/icons/hicolor/scalable/apps/fastpotify.svg
  '';

  meta = {
    description = "Fast native Spotify client with local playback and Spotify Connect";
    homepage = "https://spotifast.rocks";
    changelog = "https://github.com/crmne/spotifast/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ DmitrySkibitsky ];
    mainProgram = "spotifast";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
