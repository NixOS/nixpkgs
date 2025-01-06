{
  lib,
  fetchFromGitHub,
  buildGoModule,
  installShellFiles,
}:

buildGoModule rec {
  pname = "duf";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "muesli";
    repo = "duf";
    rev = "v${version}";
    sha256 = "sha256-bVuqX88KY+ky+fd1FU9GWP78jQc4fRDk9yRSeIesHyI=";
  };

  vendorHash = "sha256-oihi7E67VQmym9U1gdD802AYxWRrSowhzBiKg0CBDPc=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.Version=${version}"
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
}
