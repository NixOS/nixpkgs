{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "powerline-go";
  version = "1.26";

  src = fetchFromGitHub {
    owner = "justjanne";
    repo = "powerline-go";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Hrg55Ot+0SpTjWM1Ulc3EZhV14EbjEF3jRSmMfC9jLw=";
  };

  vendorHash = "sha256-W7Lf9s689oJy4U5sQlkLt3INJwtvzU2pot3EFimp7Jw=";

  ldflags = [
    "-X github.com/justjanne/powerline-go/powerline.Version=${finalAttrs.version}"
  ];

  meta = {
    description = "Powerline like prompt for Bash, ZSH and Fish";
    homepage = "https://github.com/justjanne/powerline-go";
    changelog = "https://github.com/justjanne/powerline-go/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ sifmelcara ];
    mainProgram = "powerline-go";
  };
})
