{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "gitty";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "muesli";
    repo = "gitty";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-g0D6nJiHY7cz72DSmdQZsj9Vgv/VOp0exTcLsaypGiU=";
  };

  vendorHash = "sha256-qrLECQkjXH0aTHmysq64jnXj9jgbunpVtBAIXJOEYIY=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.Version=${finalAttrs.version}"
  ];

  meta = {
    homepage = "https://github.com/muesli/gitty/";
    description = "Contextual information about your git projects, right on the command-line";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ izorkin ];
    mainProgram = "gitty";
  };
})
