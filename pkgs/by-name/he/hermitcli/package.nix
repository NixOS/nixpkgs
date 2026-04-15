{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "hermit";
  version = "0.50.2";

  src = fetchFromGitHub {
    rev = "v${finalAttrs.version}";
    owner = "cashapp";
    repo = "hermit";
    hash = "sha256-LSDLHqDCqdHsgLr3QVxewAtl2pLUNQJ1mmAyaW5+Io0=";
  };

  vendorHash = "sha256-2sNtok5J1kBvJZ0I1FOq1ZP54TsZbzqu/M3v1nA12m8=";

  subPackages = [ "cmd/hermit" ];

  ldflags = [
    "-X main.version=${finalAttrs.version}"
    "-X main.channel=stable"
  ];

  meta = {
    homepage = "https://cashapp.github.io/hermit";
    description = "Manages isolated, self-bootstrapping sets of tools in software projects";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ cbrewster ];
    platforms = lib.platforms.unix;
    mainProgram = "hermit";
  };
})
