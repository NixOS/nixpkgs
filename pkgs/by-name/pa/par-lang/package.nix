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
  version = "0-unstable-2026-03-03";

  src = fetchFromGitHub {
    owner = "faiface";
    repo = "par-lang";
    rev = "a5777923d4c94480b614c3e8cfceffe6923d1a1a";
    hash = "sha256-QGqwgSIcYc7PI/e7dZ+bWo7lrGEzvKEO2FCwtpwbFVI=";
  };

  cargoHash = "sha256-taLTRYB1Crvx0wz3IRvkPRImaRIs0mGscOjLFBkhkgE=";

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
