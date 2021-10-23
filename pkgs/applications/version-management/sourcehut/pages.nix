{ lib
, fetchFromSourcehut
, buildGoModule
}:

buildGoModule rec {
  pname = "pagessrht";
  version = "0.5.0";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "pages.sr.ht";
    rev = version;
    sha256 = "sha256-SwKiNqsPbUgJyj8qSY1c7dwDiEMznEWmFun57YmDRKw=";
  };

  vendorSha256 = "sha256-udr+1y5ApQCSPhs3yQTTi9QfzRbz0A9COYuFMjQGa74=";

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
