{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "sift";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "svent";
    repo = "sift";
    rev = "v${finalAttrs.version}";
    hash = "sha256-VH15TQ4LJt5koEmwDZtN7QRKBYCcJQzoEe/J2r6cNMw=";
  };

  vendorHash = "sha256-R1drGtR4jwB+1X++md3o0aEFm7g3IPrr5JbutrarKjY=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
  ];

  postInstall = ''
    installShellCompletion --cmd sift --bash sift-completion.bash
  '';

  meta = {
    description = "Fast and powerful alternative to grep";
    mainProgram = "sift";
    homepage = "https://sift-tool.org";
    maintainers = with lib.maintainers; [ viraptor ];
    license = lib.licenses.gpl3;
  };
})
