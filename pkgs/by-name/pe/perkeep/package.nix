{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule {
  pname = "perkeep";
  # no release or tag since 2020
  version = "0-unstable-2024-04-23";

  src = fetchFromGitHub {
    owner = "perkeep";
    repo = "perkeep";
    rev = "bb15e6eb48bc9d614673f3af9432c70a76707c22";
    hash = "sha256-FUr+OgxYHVUzaahrG/3Adn5KNYHb0S/SKKFddskuvZA=";
  };

  vendorHash = "sha256-+l1QV7/P0sS1S26xdyQygRZQGKqwbLUhgVtm/yHL6Cc=";

  subPackages = [
    "server/perkeepd"
    "cmd/pk"
    "cmd/pk-get"
    "cmd/pk-put"
    "cmd/pk-mount"
  ];

  # genfileembed gets built regardless of subPackages, to embed static
  # content into the Perkeep binaries. Remove it in post-install to
  # avoid polluting paths.
  postInstall = ''
    rm -f $out/bin/genfileembed
  '';

  meta = {
    description = "Way of storing, syncing, sharing, modelling and backing up content (née Camlistore)";
    homepage = "https://perkeep.org";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      kalbasit
      gador
    ];
  };
}
