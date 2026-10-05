{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "mastotool";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "muesli";
    repo = "mastotool";
    rev = "v${finalAttrs.version}";
    hash = "sha256-KmYUt2WXLY6i17dZ+o5HOTyMwbQnynY7IT43LIEN3B0=";
  };

  vendorHash = "sha256-uQgLwH8Z8rBfyKHMm2JHO+H1gsHK25+c34bOnMcmquA=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Collection of command-line tools to work with your Mastodon account";
    homepage = "https://github.com/muesli/mastotool";
    changelog = "https://github.com/muesli/mastotool/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "mastotool";
  };
})
