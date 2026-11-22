{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "ets";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "gdubicki";
    repo = "ets";
    rev = "v${finalAttrs.version}";
    hash = "sha256-73U5UqEKAee7Qhqeeqrojk7XDIfyfgtREhVY6VgX+2I=";
  };

  vendorHash = "sha256-lzukgI/7gxlWHY81MkK1CzpUUaZ4B+4xZ0RSZUpL62c=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${finalAttrs.version}-nixpkgs"
  ];

  nativeBuildInputs = [ installShellFiles ];

  preBuild = ''
    rm -rf fixtures
  '';

  postInstall = ''
    installManPage ets.1
  '';

  doCheck = false;

  meta = {
    description = "Command output timestamper";
    homepage = "https://github.com/gdubicki/ets/";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "ets";
  };
})
