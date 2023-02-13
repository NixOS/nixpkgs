{ lib
, fetchFromSourcehut
, buildGoModule
, unzip
}:

buildGoModule (rec {
  pname = "pagessrht";
  version = "0.7.4";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "pages.sr.ht";
    rev = version;
    sha256 = "sha256-WM9T2LS8yIqaR0PQQRgMk/tiMYcw8DZVPMqMWkj/5RY=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace "all: server" ""
  '';

  vendorSha256 = "sha256-VOqY/nStqGyfWOXnJSZX8UYyp2kzcibQM2NRNysHYEc=";

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
} // import ./fix-gqlgen-trimpath.nix { inherit unzip; gqlgenVersion= "0.17.9"; })
