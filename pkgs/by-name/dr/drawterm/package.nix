{
  stdenv,
  lib,
  fetchFrom9Front,
  unstableGitUpdater,
  installShellFiles,
  makeWrapper,
  apple-sdk_13,
  xorg,
  pkg-config,
  wayland-scanner,
  pipewire,
  wayland,
  wayland-protocols,
  libxkbcommon,
  wlr-protocols,
  pulseaudio,
  nixosTests,
  withWayland ? false,
}:
let
  withXorg = !(withWayland || stdenv.hostPlatform.isDarwin);
in
stdenv.mkDerivation {
  pname = "drawterm";
  version = "0-unstable-2025-05-18";

  src = fetchFrom9Front {
    owner = "plan9front";
    repo = "drawterm";
    rev = "a6c1ce4e0244ca70403dc4e795a9cee548159560";
    hash = "sha256-W9IsFnJE4Bpdc2K9DcRq+zRPMU9Wd4xpM0lHkh5SirQ=";
  };

  enableParallelBuilding = true;
  strictDeps = true;
  nativeBuildInputs =
    [
      installShellFiles
      makeWrapper
    ]
    ++ lib.optionals withWayland [
      pkg-config
      wayland-scanner
    ];

  buildInputs =
    lib.optionals withWayland [
      pipewire
      wayland
      wayland-protocols
      libxkbcommon
      wlr-protocols
    ]
    ++ lib.optionals withXorg [
      xorg.libX11
      xorg.libXt
    ]
    ++ lib.optional stdenv.hostPlatform.isDarwin apple-sdk_13;

  makeFlags =
    lib.optional withWayland "CONF=linux"
    ++ lib.optional (!(withWayland || stdenv.hostPlatform.isDarwin)) "CONF=unix"
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      "CONF=osx-cocoa"
      "CC=clang"
    ];

  installPhase =
    ''
      installManPage drawterm.1
    ''
    + lib.optionalString withWayland ''
      install -Dm755 -t $out/bin/ drawterm
    ''
    + lib.optionalString (!(withWayland || stdenv.hostPlatform.isDarwin)) ''
      # wrapping the oss output with pulse seems to be the easiest
      mv drawterm drawterm.bin
      install -Dm755 -t $out/bin/ drawterm.bin
      makeWrapper ${pulseaudio}/bin/padsp $out/bin/drawterm --add-flags $out/bin/drawterm.bin
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      mkdir -p $out/{Applications,bin}
      mv gui-cocoa/drawterm.app $out/Applications/
      mv drawterm $out/Applications/drawterm.app/
      ln -s $out/Applications/drawterm.app/drawterm $out/bin/
    '';

  passthru = {
    updateScript = unstableGitUpdater { shallowClone = false; };
    tests = nixosTests.drawterm;
  };

  meta = {
    description = "Connect to Plan 9 CPU servers from other operating systems";
    homepage = "https://drawterm.9front.org/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ moody ];
    platforms = with lib.platforms; linux ++ darwin;
    mainProgram = "drawterm";
  };
}
