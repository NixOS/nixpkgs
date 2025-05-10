{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nixosTests,
}:

rustPlatform.buildRustPackage rec {
  pname = "static-web-server";
  version = "2.36.1";

  src = fetchFromGitHub {
    owner = "static-web-server";
    repo = "static-web-server";
    rev = "v${version}";
    hash = "sha256-labHPDsPRyF/cxHFoOJ5n+tBFn1KF2QdB/hZnDGWf1Q=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-Sri2NTCN5vIf/5KVI+BtyOBAjkXoGpOJjP2iOh/M5NU=";

  # Some tests rely on timestamps newer than 18 Nov 1974 00:00:00
  preCheck = ''
    find docker/public -exec touch -m {} \;
  '';

  # Need to copy in the systemd units for systemd.packages to discover them
  postInstall = ''
    install -Dm444 -t $out/lib/systemd/system/ systemd/static-web-server.{service,socket}
  '';

  passthru.tests = {
    inherit (nixosTests) static-web-server;
  };

  meta = with lib; {
    description = "Asynchronous web server for static files-serving";
    homepage = "https://static-web-server.net/";
    changelog = "https://github.com/static-web-server/static-web-server/blob/v${version}/CHANGELOG.md";
    license = with licenses; [
      mit # or
      asl20
    ];
    maintainers = with maintainers; [
      figsoda
      misilelab
    ];
    mainProgram = "static-web-server";
  };
}
