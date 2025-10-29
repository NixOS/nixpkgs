{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "doxx";
  version = "0-unstable-2025-08-18";

  src = fetchFromGitHub {
    owner = "bgreenwell";
    repo = "doxx";
    rev = "5c957470de1fa937cf96cd847286e2d3ee37cbee";
    hash = "sha256-ZCvb8FnGdpzEDqYCIFjg+hiO3OZNnZ2+dSDVLx+crTU=";
  };

  cargoHash = "sha256-1i+IAQc55HYrqJm3Hx0frphSQp7jYGa6i0eOvHVMdCI=";

  postInstall = ''
    rm $out/bin/generate_test_docs
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal document viewer for .docx files";
    longDescription = ''
      `doxx` is a lightning-fast, terminal-native document viewer for
      Microsoft Word files. Built with Rust for performance and
      reliability, it brings Word documents to your command line with
      beautiful rendering, smart table support, and powerful export
      capabilities.
    '';
    homepage = "https://github.com/bgreenwell/doxx";
    changelog = "https://github.com/bgreenwell/doxx/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "doxx";
  };
})
