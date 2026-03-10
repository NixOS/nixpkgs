{
  fetchFromGitHub,
  lib,
  nix-update-script,
  stdenv,
  swift,
  swiftPackages,
  swiftpm,
  swiftpm2nix,
}:
let
  generated = swiftpm2nix.helpers ./generated;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "cgtcalc";
  version = "0-unstable-2025-10-11";

  src = fetchFromGitHub {
    owner = "mattjgalloway";
    repo = "cgtcalc";
    # Repo has no tags or releases.
    # This is the last commit before requiring Swift 6
    rev = "1cf63741ddc0a5070680cb1339ad0abff0b7d69b";
    hash = "sha256-+qgvl5y9ipVQIZlLZbkzkqb9bO7X9VGDvVsloOLZU/k=";
  };
  nativeBuildInputs = [
    swift
    swiftpm
  ];

  configurePhase = generated.configure;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp $(swiftpmBinPath)/cgtcalc $out/bin/
    runHook postInstall
  '';

  buildInputs = [
    swiftPackages.XCTest
  ];

  # libIndexStore.so: cannot open shared object file: No such file or directory
  # https://github.com/NixOS/nixpkgs/issues/379859
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "UK capital gains tax calculator written in Swift";
    homepage = "https://github.com/mattjgalloway/cgtcalc";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dwoffinden ];
    mainProgram = "cgtcalc";
    platforms = lib.platforms.all;
  };
})
