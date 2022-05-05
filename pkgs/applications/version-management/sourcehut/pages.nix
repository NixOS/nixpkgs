{ lib
, fetchFromSourcehut
, buildGoModule
, unzip
}:

buildGoModule (rec {
  pname = "pagessrht";
  version = "0.7.3";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "pages.sr.ht";
    rev = version;
    sha256 = "sha256-fHhf4VQ82/k4g8pzyuN9Pr2f8mxT8zw+2Nq0nw1Msks=";
  };

  vendorSha256 = "sha256-/+XVl6PZUMOZIiuO6vEu0dacefz2hDSObaP8JsItSTw=";

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
} // import ./fix-gqlgen-trimpath.nix {inherit unzip;})
