{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "lwc";
  version = "unstable-2022-07-26";

  src = fetchFromGitHub {
    owner = "timdp";
    repo = "lwc";
    rev = "3330928c9d82200837350f85335f5e6c09f0658b";
    hash = "sha256-HFuXA5Y274XtgqG9odDAg9SSCgUxprnojfGavnYW4LE=";
  };

  vendorHash = "sha256-av736cW0bPsGQV+XFL/q6p/9VhjOeDwkiK5DLRnRtUg=";

  ldflags = [
    "-s"
    "-X=main.version=${finalAttrs.src.rev}"
  ];

  meta = {
    description = "Live-updating version of the UNIX wc command";
    homepage = "https://github.com/timdp/lwc";
    maintainers = with lib.maintainers; [ liberodark ];
    license = lib.licenses.mit;
    mainProgram = "lwc";
  };
})
