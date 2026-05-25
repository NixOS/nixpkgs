{
  lib,
  fetchgit,
  buildGoModule,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "bombadillo";
  version = "2.4.0";

  src = fetchgit {
    url = "https://tildegit.org/sloum/bombadillo.git";
    tag = finalAttrs.version;
    hash = "sha256-FjU9AyRAdGFr1bVpkmj5STkbzCXvpxOaOj7WNQJq7A0=";
  };

  nativeBuildInputs = [ installShellFiles ];

  vendorHash = null;

  outputs = [
    "out"
    "man"
  ];

  postInstall = ''
    installManPage bombadillo.1
  '';

  meta = {
    description = "Non-web client for the terminal, supporting Gopher, Gemini and more";
    mainProgram = "bombadillo";
    homepage = "https://bombadillo.colorfield.space/";
    license = lib.licenses.gpl3;
  };
})
