{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "reaper-go";
  version = "0.2.5";

  src = fetchFromGitHub {
    owner = "ghostsecurity";
    repo = "reaper";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3kTGlGvuTSB3KOeQvhF/pNaWVU153qGqqskJd+G6FF4=";
  };

  vendorHash = "sha256-T9qTfGRLhlYrezraRRztZC2Kw4L6Fap1YQgQdnlxKhE=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/ghostsecurity/reaper/version.Date=1970-01-01T00:00:00Z"
    "-X=github.com/ghostsecurity/reaper/version.Version=${finalAttrs.version}"
  ];

  meta = {
    description = "Application security testing framework";
    homepage = "https://github.com/ghostsecurity/reaper";
    changelog = "https://github.com/ghostsecurity/reaper/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "reaper";
  };
})
