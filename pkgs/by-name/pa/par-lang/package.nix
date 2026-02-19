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
  version = "0-unstable-2026-02-10";

  src = fetchFromGitHub {
    owner = "faiface";
    repo = "par-lang";
    rev = "0bea31c716761fb608a1a43013e5c6b30ad6bd7f";
    hash = "sha256-1dqQ8h2F7erKeZAL8RRdG/uCBF39gyunS2Jna8lcv0k=";
  };

  cargoHash = "sha256-Z0aTVloZY3UQWkL3+cMqxfzACLwD7OayjBPZbQ0bk1c=";

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
