{
  lib,
  fetchFromGitHub,
  buildGoModule,
  makeWrapper,
  git,
}:

buildGoModule (finalAttrs: {
  pname = "mycorrhiza";
  version = "1.15.1";

  src = fetchFromGitHub {
    owner = "bouncepaw";
    repo = "mycorrhiza";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-Cgf2YtAatfKWxhe4xAqNRB4ktsGs3ONi5XqbjcZwzTw=";
  };

  vendorHash = "sha256-UQT6BvJT26NViZDyh6yokgW18ptMiGCSf7CgMqtD9Oc=";

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
