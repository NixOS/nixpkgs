{
  lib,
  rustPlatform,
  fetchFromGitHub,
  fetchpatch,
  stdenv,
  darwin,
  nixosTests,
}:

rustPlatform.buildRustPackage rec {
  pname = "static-web-server";
  version = "2.33.1";

  src = fetchFromGitHub {
    owner = "static-web-server";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-2vkRLQ4FKw/gkv4GuwFVcL8oDV4cNuKualQVc/X2B/Y=";
  };

  cargoHash = "sha256-wRDYzm6mYze9CX+Ug53M3wuf3Ry6l3NGTDyCL7rbdc8=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ darwin.apple_sdk.frameworks.Security ];

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
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "static-web-server";
  };
}
