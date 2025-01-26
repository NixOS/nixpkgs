{
  stdenv,
  lib,
  fetchFromGitHub,
  buildGoModule,
  makeWrapper,
  git,
}:

buildGoModule rec {
  pname = "mycorrhiza";
  version = "1.15.1";

  src = fetchFromGitHub {
    owner = "bouncepaw";
    repo = "mycorrhiza";
    rev = "v${version}";
    sha256 = "sha256-Cgf2YtAatfKWxhe4xAqNRB4ktsGs3ONi5XqbjcZwzTw=";
  };

  vendorHash = "sha256-UQT6BvJT26NViZDyh6yokgW18ptMiGCSf7CgMqtD9Oc=";

  subPackages = [ "." ];

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/mycorrhiza \
      --prefix PATH : ${lib.makeBinPath [ git ]}
  '';

  meta = with lib; {
    description = "Filesystem and git-based wiki engine written in Go using mycomarkup as its primary markup language";
    homepage = "https://github.com/bouncepaw/mycorrhiza";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ chekoopa ];
    platforms = platforms.linux;
    mainProgram = "mycorrhiza";
  };
}
