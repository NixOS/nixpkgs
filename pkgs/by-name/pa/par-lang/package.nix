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
  version = "0-unstable-2026-06-11";

  src = fetchFromGitHub {
    owner = "par-team";
    repo = "par-lang";
    rev = "0d763e90deb6bdd7888686a944efa8e1f813ded6";
    hash = "sha256-7UJwbusV+F/KI8Xvau/thRY60xRDfBc6xUdo5QhVayE=";
  };

  cargoHash = "sha256-8lG+cKN3/W+LYWhmOfDwGiq6u3nlLJaD5uNABaY0zRY=";

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
      patchelf --add-rpath ${lib.makeLibraryPath runtimeDependencies} $out/bin/par
    '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/par new hello
    diff -U3 --color=auto <($out/bin/par run --package hello 2>&1) <(echo 'Hello, World!')

    runHook postInstallCheck
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "par-playground";
      desktopName = "Par Playground";
      genericName = "Experimental concurrent programming language";
      categories = [ "Development" ];
      exec = "par playground %f";
    })
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Experimental concurrent programming language";
    homepage = "https://github.com/par-team/par-lang";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ defelo ];
    mainProgram = "par";
  };
}
