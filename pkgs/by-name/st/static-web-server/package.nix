{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nixosTests,
}:

rustPlatform.buildRustPackage rec {
  pname = "static-web-server";
  version = "2.37.0";

  src = fetchFromGitHub {
    owner = "static-web-server";
    repo = "static-web-server";
    rev = "v${version}";
    hash = "sha256-haQYouLUaDkYo9c0CA07twaEohgmSa2hn8xJevEVNFU=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-1e3of8qC1cJ9ZZt1mrfe10wjkLzUICS25TDu+HfkTyU=";

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

  meta = {
    description = "Asynchronous web server for static files-serving";
    homepage = "https://static-web-server.net/";
    changelog = "https://github.com/static-web-server/static-web-server/blob/v${version}/CHANGELOG.md";
    license = with lib.licenses; [
      mit # or
      asl20
    ];
    maintainers = with lib.maintainers; [
      figsoda
      misilelab
    ];
    mainProgram = "static-web-server";
  };
}
