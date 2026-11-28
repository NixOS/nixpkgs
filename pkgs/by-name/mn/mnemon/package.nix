{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "mnemon";
  version = "0.2.14";

  src = fetchFromGitHub {
    owner = "mnemon-dev";
    repo = "mnemon";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ayktynhKxXcow7tdUxFIl0xz+U3kJ9FiiZiMWwraHfI=";
  };

  vendorHash = "sha256-X2PBHKUnPmb4i7XOiHZqhY5/WMEHchbpDhDJuTyGl9k=";

  __structuredAttrs = true;

  ldflags = [
    "-s"
    "-X github.com/mnemon-dev/mnemon/cmd.version=${finalAttrs.version}"
  ];

  # The repository also holds test helpers (e.g. fakeprovider, trace) and
  # long-running, timing-sensitive test packages that do not belong in a
  # sandboxed build.
  subPackages = [ "." ];

  meta = {
    description = "LLM-supervised persistent memory for AI agents";
    homepage = "https://github.com/mnemon-dev/mnemon#readme";
    changelog = "https://github.com/mnemon-dev/mnemon/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    mainProgram = "mnemon";
    maintainers = with lib.maintainers; [ EllianCarlos ];
  };
})
