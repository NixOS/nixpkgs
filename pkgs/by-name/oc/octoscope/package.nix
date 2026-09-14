{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "octoscope";
  version = "0.8.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "gfazioli";
    repo = "octoscope";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2Wz7l1ev9TOdo2p7poa+WinqgqD0lvjOKZs10UYYDEw=";
  };

  vendorHash = "sha256-d2bn0MS4GMSX5bW/aCkJcKW2DKJo/jQBBh8J8N3Z5Ys=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${finalAttrs.version}"
  ];

  meta = {
    description = "A terminal dashboard for your GitHub account, or anyone else's public GitHub profile.";
    homepage = "https://github.com/gfazioli/octoscope";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gwg313 ];
    mainProgram = "octoscope";
  };
})
