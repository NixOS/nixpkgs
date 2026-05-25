{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:
buildGoModule (finalAttrs: {
  pname = "jqfmt";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "noperator";
    repo = "jqfmt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3PYIyjZm265atBAfuj5aHmWoAv4H29I7gN4/rjl1d0o=";
  };

  vendorHash = "sha256-avpZSgQKFZxLmYGj+2Gi+wSDHnAgF0/hyp4HtoQ0ZCo=";

  meta = {
    description = "Like gofmt, but for jq";
    homepage = "https://github.com/noperator/jqfmt";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ heisfer ];
    mainProgram = "jqfmt";
  };
})
