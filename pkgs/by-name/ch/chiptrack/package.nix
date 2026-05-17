{
  stdenv,
  rustPlatform,
  lib,
  fetchFromGitHub,
  alsa-lib,
  brotli,
  cmake,
  fontconfig,
  libglvnd,
  libxkbcommon,
  libx11,
  libxcursor,
  libxext,
  libxi,
  libxrandr,
  makeWrapper,
  pkg-config,
  python3,
  wayland,
  zlib,
}:

rustPlatform.buildRustPackage {
  pname = "chiptrack";
  version = "0.5-unstable-2026-02-09";

  src = fetchFromGitHub {
    owner = "jturcotte";
    repo = "chiptrack";
    rev = "3cb0caa5bbc23d0579cdad8187c4371bdf0723a3";
    hash = "sha256-jqtWmhP8h8v8bMPVgVZtraWOXRpEir6WnSoCg5EJKs0=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    cmake
    makeWrapper
    pkg-config
    python3
  ];

  buildInputs = [
    fontconfig
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ alsa-lib ];

  # Has git dependencies

  cargoHash = "sha256-C9sNSD51Q0U4f4xhnTQI/457uk/yFSrEdok81bDgcc0=";

  postFixup = ''
    wrapProgram $out/bin/chiptrack \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath (
          [
            brotli
            zlib
          ]
          ++ lib.optionals stdenv.hostPlatform.isLinux [
            libglvnd
            libxkbcommon
            libx11
            libxcursor
            libxext
            libxrandr
            libxi
            wayland
          ]
        )
      }
  '';

  meta = {
    description = "Programmable cross-platform sequencer for the Game Boy Advance sound chip";
    homepage = "https://github.com/jturcotte/chiptrack";
    license = with lib.licenses; [
      mit # main
      gpl3Only # GPL dependencies
    ];
    mainProgram = "chiptrack";
    maintainers = with lib.maintainers; [ OPNA2608 ];
    # Various issues with wrong max macOS version & misparsed target conditional checks, can't figure out the magic combination for this
    broken = stdenv.hostPlatform.isDarwin;
  };
}
