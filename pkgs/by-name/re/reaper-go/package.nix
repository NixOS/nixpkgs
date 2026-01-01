{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "reaper-go";
<<<<<<< HEAD
  version = "0.2.6";
=======
  version = "0.2.5";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "ghostsecurity";
    repo = "reaper";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-ZSHG4pQTo+Z05MvBqFoscMaZuezScTuszOF8hn4UZXs=";
  };

  vendorHash = "sha256-Kn/anDDHWfapWB/ZHu4MRmEQ7Nn8hjUMS+LWK9Dx/g4=";
=======
    hash = "sha256-3kTGlGvuTSB3KOeQvhF/pNaWVU153qGqqskJd+G6FF4=";
  };

  vendorHash = "sha256-T9qTfGRLhlYrezraRRztZC2Kw4L6Fap1YQgQdnlxKhE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
