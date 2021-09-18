{ lib
, fetchFromSourcehut
, buildGoModule
}:
let
  version = "0.4.10";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "pages.sr.ht";
    rev = version;
    sha256 = "sha256-Lq/xCCAywxxjX5nHbOvmCaQ4wtLgjcMo3Qc7xO1fdAs=";
  };

in
buildGoModule {
  inherit src version;
  pname = "pagessrht";
  vendorSha256 = "sha256-YFRBoflFy48ipTvXdZ4qPSEgTIYvm4752JRZSzRG++U=";

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
