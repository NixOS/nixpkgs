{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "noxdir";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "crumbyte";
    repo = "noxdir";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Dq8u2h5l95ZQ7DEi60G8IAeF9kwYQY0KUxq3lq9e3Tk=";
  };

  vendorHash = "sha256-Wg1v2oAbaj7gWgj2AgDPZHdsDebgDs8Xcyvo3QYZ1dU=";

  checkPhase = ''
    runHook preCheck
    go test -v -buildvcs -race ./...
    runHook postCheck
  '';

  meta = {
    description = "Terminal utility for visualizing file system usage";
    homepage = "https://github.com/crumbyte/noxdir";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ruiiiijiiiiang ];
    mainProgram = "noxdir";
  };
})
