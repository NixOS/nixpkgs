{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "labctl";
  version = "0.0.22-unstable-2024-05-10";

  src = fetchFromGitHub {
    owner = "labctl";
    repo = "labctl";
    rev = "1a8b11402def10819d36b9f7f44e82612ef22674";
    hash = "sha256-px5jrfllo6teJaNrqIQVyqMwArCw625xSVM7V/xW/IA=";
  };

  nativeBuildInputs = [ installShellFiles ];

  vendorHash = "sha256-Ycr/IZckIFysS9Goes58hhgh96UMRHjYWfWlQU23mXk=";

  ldflags = [
    "-X=github.com/labctl/labctl/app.version=${version}"
    "-X=github.com/labctl/labctl/app.commit=${src.rev}"
    "-X=github.com/labctl/labctl/app.date=1970-01-01T00:00:00Z"
  ];

  postInstall = ''
    local INSTALL="$out/bin/labctl"
    installShellCompletion --cmd labctl \
      --bash <(echo "complete -C $INSTALL labctl") \
      --zsh <(echo "complete -o nospace -C $INSTALL labctl")
  '';

  meta = with lib; {
    description = "Collection of helper tools for network engineers, while configuring and experimenting with their own network labs";
    homepage = "https://labctl.net";
    changelog = "https://github.com/labctl/labctl/releases";
    license = licenses.asl20;
    maintainers = [ ];
    mainProgram = "labctl";
  };
}
