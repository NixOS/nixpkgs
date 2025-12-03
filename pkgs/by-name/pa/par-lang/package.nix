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
  xorg,
  makeDesktopItem,
  copyDesktopItems,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "par-lang";
  version = "0-unstable-2025-12-02";

  src = fetchFromGitHub {
    owner = "faiface";
    repo = "par-lang";
    rev = "aa01ca58034b91f64b3ad5c849bb0e97762221af";
    hash = "sha256-W68fareSkbnHnFy0IFIShOebC0cCcWqRWoaez3drsYI=";
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
        xorg.libX11
        xorg.libXcursor
        xorg.libXi
        xorg.libXrandr
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
