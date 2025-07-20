{
  lib,
  fetchFromGitHub,
  buildGoModule,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "duf";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "muesli";
    repo = "duf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bVuqX88KY+ky+fd1FU9GWP78jQc4fRDk9yRSeIesHyI=";
  };

  vendorHash = "sha256-oihi7E67VQmym9U1gdD802AYxWRrSowhzBiKg0CBDPc=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.Version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage duf.1
  '';

  meta = {
    homepage = "https://github.com/muesli/duf/";
    description = "Disk Usage/Free Utility";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      figsoda
      penguwin
      sigmasquadron
    ];
    mainProgram = "duf";
  };
})
