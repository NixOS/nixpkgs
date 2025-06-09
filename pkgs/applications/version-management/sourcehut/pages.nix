{
  lib,
  fetchFromSourcehut,
  buildGoModule,
  unzip,
}:

buildGoModule (
  rec {
    pname = "pagessrht";
    version = "0.16.0";

    src = fetchFromSourcehut {
      owner = "~sircmpwn";
      repo = "pages.sr.ht";
      rev = version;
      hash = "sha256-XnKNXYzg9wuL4U2twkAspaQJZy2HWLQQQl9AITtipVU=";
    };

    patches = ./patches/core-go-update/pages/patch-deps.patch;

    postPatch = ''
      substituteInPlace Makefile \
        --replace-fail "all: server daily" ""
    '';

    vendorHash = "sha256-klDROxNvR7lk79ptckulImVVwsAfcnKtJJAaevlZSWU=";

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
    gqlgenVersion = "0.17.64";
  }
)
