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
  vendorSha256 = "sha256-xOd9i+PNlLxZrw/+z/C9V+AbOLEociW2YHY+x1K+mJI=";

  patches = [
    # Upstream after 0.4.8
    ./pages-fix-syntax-error-in-schema.sql.patch
  ];

  postInstall = ''
    mkdir -p $out/share/sql/
    cp -r -t $out/share/sql/ schema.sql migrations
  '';

  meta = with lib; {
    homepage = "https://git.sr.ht/~sircmpwn/pages.sr.ht";
    description = "Web hosting service for the sr.ht network";
    license = licenses.agpl3;
    maintainers = with maintainers; [ eadwu ];
  };
}
