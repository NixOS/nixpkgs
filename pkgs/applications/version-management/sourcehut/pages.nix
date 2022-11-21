{ lib
, fetchFromSourcehut
, buildGoModule
, unzip
}:

buildGoModule (rec {
  pname = "pagessrht";
  version = "0.9.0";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "pages.sr.ht";
    rev = version;
    sha256 = "sha256-yzNaUmdhMBgZi6F7EkFs58ZCsI+0K9SJgVxfHzUFay8=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace "all: server" ""
  '';

  vendorSha256 = "sha256-hQmnaYZD6QIlSS6MtocvnXdXHi+z69Tm7mwOq21yUmQ=";

  postInstall = ''
    mkdir -p $out/share/sql/
    cp -r -t $out/share/sql/ schema.sql migrations
  '';

  meta = with lib; {
    homepage = "https://git.sr.ht/~sircmpwn/pages.sr.ht";
    description = "Web hosting service for the sr.ht network";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ eadwu ];
  };
  # There is no ./loaders but this does not cause troubles
  # to go generate
} // import ./fix-gqlgen-trimpath.nix { inherit unzip; gqlgenVersion= "0.17.20"; })
