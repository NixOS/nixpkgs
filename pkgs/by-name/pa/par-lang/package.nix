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
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "par-lang";
  version = "0-unstable-2025-11-20";

  src = fetchFromGitHub {
    owner = "faiface";
    repo = "par-lang";
    rev = "1f6671068d93defdd14a7ff86b9fc167b6949906";
    hash = "sha256-skBH5m/cJ7CZJqfDtKxk8AqaP/dwGCmEb9CDtmMUzlU=";
  };

  cargoHash = "sha256-sW+gAIp/DjlTo44QDXpP6COrCK/CcDlx3no284MEQJo=";

  nativeBuildInputs = [ pkg-config ];

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

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Experimental concurrent programming language";
    homepage = "https://github.com/faiface/par-lang";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ defelo ];
    mainProgram = "par-lang";
  };
}
