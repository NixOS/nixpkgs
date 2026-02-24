{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "ain";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "jonaslu";
    repo = "ain";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jZTdFA3ZNb0xIN7+ne5bz6jMpj4jqZ/JHxz2x83fBm8=";
  };

  vendorHash = "sha256-VLn7JPYYFmQ/9c0zKHWJBqtxwCbWgsN4FHlXrQiKMj4=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.gitSha=${finalAttrs.src.tag}"
  ];

  # need network
  doCheck = false;

  meta = {
    description = "HTTP API client for the terminal";
    homepage = "https://github.com/jonaslu/ain";
    changelog = "https://github.com/jonaslu/ain/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "ain";
  };
})
