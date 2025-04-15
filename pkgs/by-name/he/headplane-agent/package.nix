{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:
let
  version = "0.5.10";
in
buildGoModule {
  pname = "hp_agent";
  src = fetchFromGitHub {
    repo = "headplane";
    owner = "tale";
    rev = version;
    hash = "sha256-0sckkbjyjrgshzmxx1biylxasybcmybarmqgfhl2cn6yy40dw6p4";
  };

  vendorHash = "sha256-G0kahv3mPTL/mxU2U+0IytJaFVPXMbMBktbLMfM0BO8=";
  ldflags = [
    "-s"
    "-w"
  ];
  env.CGO_ENABLED = 0;
  meta = {
    description = "An optional sidecar process providing additional features for headplane";
    homepage = "https://github.com/tale/headplane";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.igor-ramazanov ];
    mainProgram = "hp_agent";
    platforms = lib.platforms.linux;
  };
}
