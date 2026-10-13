{
  stdenv,
  lib,
  fetchFrom9Front,
  unstableGitUpdater,
  installShellFiles,
  makeWrapper,
  libxt,
  libx11,
  pkg-config,
  wayland-scanner,
  pipewire,
  wayland,
  wayland-protocols,
  libxkbcommon,
  libdecor,
  llvmPackages,
  pulseaudio,
  nixosTests,
  withWayland ? false,
}:
let
  withXorg = !(withWayland || stdenv.hostPlatform.isDarwin);
in
stdenv.mkDerivation {
  pname = "drawterm";
  version = "0-unstable-2026-08-15";

  src = fetchFrom9Front {
    owner = "plan9front";
    repo = "drawterm";
    rev = "45ab4d2ce7fd2443ad7264bd0ce14bf294d8b9e6";
    hash = "sha256-orsBajeHXW/ANpdemE1HzQaa602B4mpGrVt3QdbqCR0=";
  };

  enableParallelBuilding = true;
  strictDeps = true;
  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    llvmPackages.lld
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
      libdecor
    ]
    ++ lib.optionals withXorg [
      libx11
      libxt
    ];

  env.NIX_CFLAGS_LINK = lib.optionalString stdenv.hostPlatform.isDarwin "-fuse-ld=lld";
  makeFlags =
    lib.optional withWayland "CONF=linux"
    ++ lib.optional (!(withWayland || stdenv.hostPlatform.isDarwin)) "CONF=unix"
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      "CONF=osx-cocoa"
      "CC=clang"
    ];

  installPhase = ''
    runHook preInstall
    installManPage drawterm.1
  ''
  + lib.optionalString withWayland ''
    install -Dm755 -t $out/bin/ drawterm
  ''
  + lib.optionalString (!(withWayland || stdenv.hostPlatform.isDarwin)) ''
    # wrapping the oss output with pulse seems to be the easiest
    mv drawterm drawterm.bin
    install -Dm755 -t $out/bin/ drawterm.bin
    makeWrapper ${lib.getExe' pulseaudio "padsp"} $out/bin/drawterm --add-flags $out/bin/drawterm.bin
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/{Applications,bin}
    mv gui-cocoa/drawterm.app $out/Applications/
    mv drawterm $out/Applications/drawterm.app/
    ln -s $out/Applications/drawterm.app/drawterm $out/bin/
  ''
  + ''
    runHook postInstall
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
