{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  pkg-config,
  openssl,
  libGL,
  libxkbcommon,
  wayland,
  libxrandr,
  libxi,
  libxcursor,
  libx11,
  makeDesktopItem,
  copyDesktopItems,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "par-lang";
  version = "0-unstable-2026-01-23";

  src = fetchFromGitHub {
    owner = "faiface";
    repo = "par-lang";
    rev = "d2de05c1dd7e6020727900e4e7c638ece3435fef";
    hash = "sha256-adR6M3EINAtGExkHmL7TiUlSHuFUk92+/F2u+SAK6oQ=";
  };

  cargoHash = "sha256-sW+gAIp/DjlTo44QDXpP6COrCK/CcDlx3no284MEQJo=";

  nativeBuildInputs = [
    pkg-config
    copyDesktopItems
  ];

  buildInputs = [ openssl ];

  postFixup =
    let
      runtimeDependencies = [
        libGL
        libxkbcommon
        wayland
        libx11
        libxcursor
        libxi
        libxrandr
      ];
    in
    lib.optionalString stdenv.hostPlatform.isLinux ''
      patchelf --add-rpath ${lib.makeLibraryPath runtimeDependencies} $out/bin/par-lang
    '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    echo 'def Main = Console.Open.print("Hello, World!").close' > test.par
    diff -U3 --color=auto <($out/bin/par-lang run test.par) <(echo 'Hello, World!')

    runHook postInstallCheck
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "par-playground";
      desktopName = "Par Playground";
      genericName = "Experimental concurrent programming language";
      categories = [ "Development" ];
      exec = "par-lang playground %f";
    })
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Experimental concurrent programming language";
    homepage = "https://github.com/faiface/par-lang";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ defelo ];
    mainProgram = "par-lang";
  };
}
