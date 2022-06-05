{ lib
, fetchFromSourcehut
, buildGoModule
}:

buildGoModule rec {
  pname = "pagessrht";
  version = "0.6.2";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "pages.sr.ht";
    rev = version;
    sha256 = "sha256-ob0+t9V2o8lhVC6fXbi1rNm0Mnbs+GoyAmhBqVZ13PA=";
  };

  vendorSha256 = "sha256-b0sHSH0jkKoIVq045N96wszuLJDegkkj0v50nuDFleU=";

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
}
