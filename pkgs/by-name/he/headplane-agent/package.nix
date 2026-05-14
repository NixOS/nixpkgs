{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:
buildGoModule (finalAttrs: {
  pname = "headplane-agent";
  __structuredAttrs = true;
  # Note, if you are upgrading this, you should upgrade headplane at the same time
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "tale";
    repo = "headplane";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2C/Pn2M2aHADtoljSFg9hz6xOaZp6IRI77jjy+LDAgw=";
  };

  vendorHash = "sha256-MvrqKMD+A+qBZmzQv+T9920U5uJop+pjfJpZdm2ZqEA=";
  subPackages = [ "cmd/hp_agent" ];

  ldflags = [
    "-s"
    "-w"
  ];
  env.CGO_ENABLED = 0;

  meta = {
    description = "Optional sidecar process providing additional features for headplane";
    homepage = "https://github.com/tale/headplane";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      igor-ramazanov
      stealthbadger747
    ];
    mainProgram = "hp_agent";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
