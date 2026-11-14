{
  lib,
  fetchFromGitHub,
  rustPlatform,
  go-md2man,
  installShellFiles,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "maker-panel";
  version = "0.12.4";

  src = fetchFromGitHub {
    owner = "twitchyliquid64";
    repo = "maker-panel";
    rev = finalAttrs.version;
    hash = "sha256-cQ2AJnqPOZFy7IoYRbvp/x719gXoTlHM0gEdQxjwmjY=";
  };

  cargoHash = "sha256-H4eKZlay0IZ8vAclGruDAyh7Vd6kCvGLxJ5y/cuF+F4=";

  cargoPatches = [ ./update-gerber-types-to-0.3.patch ];

  nativeBuildInputs = [
    go-md2man
    installShellFiles
  ];

  postBuild = ''
    go-md2man --in docs/spec-reference.md --out maker-panel.5
  '';

  postInstall = ''
    installManPage maker-panel.5
  '';

  meta = {
    description = "Make mechanical PCBs by combining shapes together";
    homepage = "https://github.com/twitchyliquid64/maker-panel";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
