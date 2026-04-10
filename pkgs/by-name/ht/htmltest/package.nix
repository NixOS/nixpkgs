{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "htmltest";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "wjdp";
    repo = "htmltest";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-8tkk476kGEfHo3XGu3/0r6fhX1c4vkYiUACpw0uEu2g=";
  };

  vendorHash = "sha256-dTn5aYb5IHFbksmhkXSTJtI0Gnn8Uz0PMZPFzFKMo38=";

  ldflags = [
    "-w"
    "-s"
    "-X main.version=${finalAttrs.version}"
  ];

  # tests require network access
  doCheck = false;

  meta = {
    description = "Tool to test generated HTML output";
    mainProgram = "htmltest";
    longDescription = ''
      htmltest runs your HTML output through a series of checks to ensure all your
      links, images, scripts references work, your alt tags are filled in, etc.
    '';
    homepage = "https://github.com/wjdp/htmltest";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
})
