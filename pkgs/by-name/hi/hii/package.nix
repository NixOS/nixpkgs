{
  stdenv,
  lib,
  fetchFromGitHub,
  buildGoModule,
  installShellFiles,
}:

buildGoModule {
  pname = "hii";
  version = "1.1.5-unstable-2025-08-03";

  src = fetchFromGitHub {
    owner = "nmeum";
    repo = "hii";
    rev = "6c07f4955a85eb32fcc0589238d5a00c1a8722f2";
    sha256 = "sha256-CXpN57T+o5MPoUxwL48GfEedz05TK8+jPFgdSIdqk+8=";
  };

  vendorHash = "sha256-lN/ESmpS8K0eC21F5RUbMN35I9b4uBE86CgAnhF1+VA=";

  outputs = [
    "out"
    "man"
    "doc"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage hii.1 hii.5
    install -Dm644 README.md $doc/share/doc/hii/README.md
  '';

  meta = {
    homepage = "https://github.com/nmeum/hii/";
    license = lib.licenses.gpl3Only;
    description = "A file-based IRC client inspired by ii";
    mainProgram = "hii";
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.sternenseemann ];
  };
}
