{
  lib,
  installShellFiles,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "leaf-markdown-viewer";
  version = "1.28.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "RivoLink";
    repo = "leaf";
    tag = finalAttrs.version;
    hash = "sha256-xAO52Xhu2QOXzg/TJubTguJ7URddKnQekACnvytx5Qw=";
  };

  cargoHash = "sha256-Y+sOyHOSEjKW+NEpSjZgqJwXH3IOSFMBGM84oytRNsc=";

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    installShellCompletion --cmd leaf $src/completions/leaf.{bash,fish,nu,zsh}
  '';

  meta = {
    description = "Terminal Markdown previewer — GUI-like experience";
    homepage = "https://github.com/RivoLink/leaf";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ SConaway ];
  };
})
