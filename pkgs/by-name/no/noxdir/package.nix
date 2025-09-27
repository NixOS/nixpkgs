{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "noxdir";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "crumbyte";
    repo = "noxdir";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fy/ETTGJKgVubf5s+Lgc0rW7q571mMjVh7V7/VBrRD4=";
  };

  vendorHash = "sha256-NtrTLF6J+4n+bnVsfs+WAmlYeL0ElJzwaiK1sk59z9k=";

  checkPhase = ''
    runHook preCheck
    go test -v -buildvcs -race ./...
    runHook postCheck
  '';

  meta = {
    description = "Terminal utility for visualizing file system usage.";
    homepage = "https://github.com/crumbyte/noxdir";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ruiiiijiiiiang ];
    mainProgram = "noxdir";
  };
})
