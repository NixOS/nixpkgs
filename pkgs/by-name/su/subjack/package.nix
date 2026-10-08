{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "subjack";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "haccer";
    repo = "subjack";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AHzBPtMpXy8ZG+lh7PpcvkJkdUal3ONhEQIhMVFSx+A=";
  };

  vendorHash = "sha256-Ma4kAcMfYm1ltOaAX39j78lxaAnWq03FYyB6rnKv9y8=";

  __structuredAttrs = true;

  meta = {
    description = "DNS Takeover Scanner written in Go";
    mainProgram = "subjack";
    homepage = "https://github.com/haccer/subjack";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ fxai ];
  };
})
