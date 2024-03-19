{ lib
, fetchFromSourcehut
, buildGoModule
, unzip
}:

buildGoModule (rec {
  pname = "pagessrht";
  version = "0.15.4";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "pages.sr.ht";
    rev = version;
    hash = "sha256-3kdQVIL7xaIPu2elxj1k+4/y75bd+OKP5+VPSniF7w8=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace "all: server" ""
  '';

  vendorHash = "sha256-DP+6rxjiXzs0RbSuMD20XwO/+v7QXCNgXj2LxZ96lWE=";

  postInstall = ''
    mkdir -p $out/share/sql/
    cp -r -t $out/share/sql/ schema.sql migrations
  '';

  meta = with lib; {
    homepage = "https://git.sr.ht/~sircmpwn/pages.sr.ht";
    description = "Web hosting service for the sr.ht network";
    mainProgram = "pages.sr.ht";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ eadwu christoph-heiss ];
  };
  # There is no ./loaders but this does not cause troubles
  # to go generate
} // import ./fix-gqlgen-trimpath.nix { inherit unzip; })
