{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:
buildGoModule (finalAttrs: {
  pname = "gnparser";
  version = "1.14.2";

  src = fetchFromGitHub {
    owner = "gnames";
    repo = "gnparser";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QqBg0BUbP8p1sqVRVSny0oqBIc4wY0jX8VlivOPn2bg=";
  };

  vendorHash = "sha256-Oitse5Te35Cs8Ub7ueDw60JM5p8FOsyMsZif8OQQ+uE=";

  subPackages = [ "gnparser" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/gnames/gnparser/ent/version.Version=${finalAttrs.version}"
  ];
  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage man/gnparser.1
  '';
  meta = {
    description = "Parser for scientific names";
    homepage = "https://github.com/gnames/gnparser";
    changelog = "https://github.com/gnames/gnparser/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "gnparser";
    maintainers = with lib.maintainers; [ attila ];
  };
})
