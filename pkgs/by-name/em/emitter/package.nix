{
  lib,
  buildGoModule,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,
}:

buildGoModule rec {
  pname = "emitter";
  version = "3.1";

  src = fetchFromGitHub {
    owner = "emitter-io";
    repo = "emitter";
    tag = "v${version}";
    hash = "sha256-eWBgRG0mLdiJj1TMSAxYPs+8CqLNaFUOW6/ghDn/zKE=";
  };

  vendorHash = "sha256-6K9KAvb+05nn2pFuVDiQ9IHZWpm+q01su6pl7CxXxBY=";

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  ldflags = [
    "-X github.com/emitter-io/emitter/internal/command/version.version=${version}"
    "-X github.com/emitter-io/emitter/internal/command/version.commit=${src.rev}"
  ];

  doCheck = true;

  checkFlags = [
    # Tests require network access
    "-skip=^Test(NewClient|Statsd_BadSnapshot|Statsd_Configure|Join|Random)$"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "High performance, distributed and low latency publish-subscribe platform";
    homepage = "https://emitter.io/";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ sikmir ];
    mainProgram = "emitter";
  };
}
