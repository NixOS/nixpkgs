{
  lib,
  fetchFromSourcehut,
  buildGoModule,
  unzip,
}:

buildGoModule (
  rec {
    pname = "pagessrht";
    version = "0.15.7";

    src = fetchFromSourcehut {
      owner = "~sircmpwn";
      repo = "pages.sr.ht";
      rev = version;
      hash = "sha256-Lobuf12ybSO7Y4ztOLMFW0dmPFaBSEPCy4Nmh89tylI=";
    };

    postPatch = ''
      substituteInPlace Makefile \
        --replace "all: server" ""

      # fix build failure due to unused import
      substituteInPlace server.go \
        --replace-warn '	"fmt"' ""
    '';

    vendorHash = "sha256-9hpOkP6AYSZe7MW1mrwFEKq7TvVt6OcF6eHWY4jARuU=";

    postInstall = ''
      mkdir -p $out/share/sql/
      cp -r -t $out/share/sql/ schema.sql migrations
    '';

    meta = with lib; {
      homepage = "https://git.sr.ht/~sircmpwn/pages.sr.ht";
      description = "Web hosting service for the sr.ht network";
      mainProgram = "pages.sr.ht";
      license = licenses.agpl3Only;
      maintainers = with maintainers; [
        eadwu
        christoph-heiss
      ];
    };
    # There is no ./loaders but this does not cause troubles
    # to go generate
  }
  // import ./fix-gqlgen-trimpath.nix {
    inherit unzip;
    gqlgenVersion = "0.17.42";
  }
)
