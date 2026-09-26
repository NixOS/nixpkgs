{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "json-patch";
  version = "5.9.11";

  src = fetchFromGitHub {
    owner = "evanphx";
    repo = "json-patch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lRgz3Bw2mwQSfXvXmKUcWfexEf3YHBFy47tqWB6lzWs=";
  };

  modRoot = "v5";

  vendorHash = "sha256-W6XVd68MS0ungMgam8jefYMVhyiN6/DB+bliFzs2rdk=";

  env.CGO_ENABLED = 0;

  ldflags = [ "-s" ];

  meta = {
    description = "CLI tool for applying RFC6902 patches";
    homepage = "https://github.com/evanphx/json-patch";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ davidweisse ];
    mainProgram = "json-patch";
  };
})
