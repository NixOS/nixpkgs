{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nixosTests,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "static-web-server";
  version = "2.39.0";

  src = fetchFromGitHub {
    owner = "static-web-server";
    repo = "static-web-server";
    rev = "v${finalAttrs.version}";
    hash = "sha256-iprQlSHO+ac7v1odVoS/9IU+Zov8/xh1l9pm1PJE8fs=";
  };

  cargoHash = "sha256-rNrGlgUvPezX7RnKhprRjl9DiJ/Crt4phmxnfY9tNXA=";

  # static-web-server already has special handling for files with modification
  # time = unix epoch, but the nix store is unix epoch + 1 second.
  patches = [ ./include-unix-time-plus-one.diff ];

  # Some tests which implicitly relied on the above behavior now break.  Force
  # an mtime update to fix.
  postUnpack = ''
    find . -exec touch -m {} +
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
    changelog = "https://github.com/static-web-server/static-web-server/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [
      mit # or
      asl20
    ];
    maintainers = with lib.maintainers; [
      misilelab
    ];
    mainProgram = "static-web-server";
  };
})
