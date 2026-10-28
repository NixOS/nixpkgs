{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "noxdir";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "crumbyte";
    repo = "noxdir";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SwNJCOdVmYGp2awp1H5psnc4tyDY57/l2BpSJGRfBS0=";
  };

  vendorHash = "sha256-citZvLDKdhkWma3XKSfMvPOTo1xEpZhovkWTsMTyO+k=";

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
