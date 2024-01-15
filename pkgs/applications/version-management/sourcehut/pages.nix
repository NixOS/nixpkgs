{ lib
, fetchFromSourcehut
, buildGoModule
, unzip
}:

buildGoModule (rec {
  pname = "pagessrht";
  version = "0.13.0";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "pages.sr.ht";
    rev = version;
    sha256 = "sha256-vUN6c6cyhcLI8bKrFYKoxlBQ29VS/bowpSfBRmi47wg=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace "all: server" ""
  '';

  vendorHash = "sha256-GKuHkUqSVBLN3k8YsFtxdmdHFkqKo9YZqDk2GBmbfWo=";

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
} // import ./fix-gqlgen-trimpath.nix { inherit unzip; })
