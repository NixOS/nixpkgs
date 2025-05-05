{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nix-update-script,
}:
buildGoModule {
  pname = "jqfmt";
  version = "0-unstable-2024-08-15";

  src = fetchFromGitHub {
    owner = "noperator";
    repo = "jqfmt";
    rev = "8fc6f864c295e6bd6b08f36f503b3d809270da61";
    hash = "sha256-tvFp1SJeosJdCHs3c+vceBfacypJc/aFYSj55mBfkB8=";
  };

  vendorHash = "sha256-avpZSgQKFZxLmYGj+2Gi+wSDHnAgF0/hyp4HtoQ0ZCo=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch=main" ]; };

  meta = {
    description = "Like gofmt, but for jq";
    homepage = "https://github.com/noperator/jqfmt";
    license = lib.licenses.mit; # Doesn't have Licence file, but Readme points to MIT
    maintainers = with lib.maintainers; [ heisfer ];
    mainProgram = "jqfmt";
  };
}
