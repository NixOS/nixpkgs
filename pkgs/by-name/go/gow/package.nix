{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule {
  pname = "gow";
  version = "0-unstable-2025-03-28";

  src = fetchFromGitHub {
    owner = "mitranim";
    repo = "gow";
    rev = "576bf37beebc38106597ce1092f5b438027c8bdc";
    hash = "sha256-+1u3eUwo7S7Iun98JobO9Y0nXNo8RVzKlKX5O1QCn/w=";
  };

  vendorHash = "sha256-L/GyzLH2j1rvSfsuxQ5pC8M42nxZDepuMRiGmKDS3vE=";

  ldflags = [
    "-s"
    "-w"
  ];

  doInstallCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/gow -h

    runHook postInstallCheck
  '';

  meta = {
    description = "Missing watch mode for Go commands. Watch Go files and execute a command like \"go run\" or \"go test\"";
    longDescription = ''
      Go Watch: missing watch mode for the go command. It's invoked exactly
      like go, but also watches Go files and reruns on changes.
    '';
    homepage = "https://github.com/mitranim/gow";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ jk ];
    platforms = lib.platforms.unix;
    mainProgram = "gow";
  };
}
