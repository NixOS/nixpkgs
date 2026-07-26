{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchpatch,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "sift";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "svent";
    repo = "sift";
    rev = "v${finalAttrs.version}";
    hash = "sha256-IZ4Hwg5NzdSXtrIDNxtkzquuiHQOmLV1HSx8gpwE/i0=";
  };

  vendorHash = "sha256-y883la4R4jhsS99/ohgBC9SHggybAq9hreda6quG3IY=";

  patches = [
    # Add Go Modules support
    (fetchpatch {
      url = "https://github.com/svent/sift/commit/b56fb3d0fd914c8a6c08b148e15dd8a07c7d8a5a.patch";
      hash = "sha256-mFCEpkgQ8XDPRQ3yKDZ5qY9tKGSuHs+RnhMeAlx33Ng=";
    })
  ];

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
