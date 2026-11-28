{
  lib,
  fetchFromGitHub,
  buildGoModule,
  makeWrapper,
  git,
}:

buildGoModule (finalAttrs: {
  pname = "mycorrhiza";
  version = "1.16.0";

  src = fetchFromGitHub {
    owner = "bouncepaw";
    repo = "mycorrhiza";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-8xkJSZhHvznfRpoEMdCRL7n35B83BncAEsf3lFsAkuk=";
  };

  vendorHash = "sha256-6CR28JXjnXIBrsruHqXIFfBXFl3NXlOj5/ESjuDJxcE=";

  subPackages = [ "." ];

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/mycorrhiza \
      --prefix PATH : ${lib.makeBinPath [ git ]}
  '';

  meta = {
    description = "Filesystem and git-based wiki engine written in Go using mycomarkup as its primary markup language";
    homepage = "https://github.com/bouncepaw/mycorrhiza";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ chekoopa ];
    platforms = lib.platforms.unix;
    mainProgram = "mycorrhiza";
  };
})
