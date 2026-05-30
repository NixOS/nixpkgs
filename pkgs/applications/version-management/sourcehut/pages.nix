{
  lib,
  fetchFromSourcehut,
  buildGoModule,
  unzip,
}:

buildGoModule (
  rec {
    pname = "pagessrht";
    version = "0.17.12";

    src = fetchFromSourcehut {
      owner = "~sircmpwn";
      repo = "pages.sr.ht";
      rev = version;
      hash = "sha256-TUrCi5tw5mGp49hXru3jq8F17TPdAgttYDmV0WjwlWM=";
    };

    postPatch = ''
      substituteInPlace Makefile \
        --replace-fail "all: all-bin all-share" ""
    '';

    vendorHash = "sha256-AgcIXS1n3eJlt+vS9H4J0RATVhPC/2BmSVK6q+ALPvU=";

    subPackages = [
      "./cmd/pages.sr.ht"
      "./cmd/daily"
    ];

    postInstall = ''
      mkdir -p $out/share/sql/
      cp -r -t $out/share/sql/ schema.sql migrations
    '';

    meta = with lib; {
      homepage = "https://git.sr.ht/~sircmpwn/pages.sr.ht";
      description = "Web hosting service for the sr.ht network";
      mainProgram = "pages.sr.ht";
      license = licenses.agpl3Only;
      maintainers = [ ];
    };
  }
  // import ./fix-gqlgen-trimpath.nix {
    inherit unzip;
    gqlgenVersion = "0.17.64";
  }
)
