{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  litestream,
  litestreamSupport ? false,
}:

buildGoModule (finalAttrs: {
  pname = "picoshare";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "mtlynch";
    repo = "picoshare";
    tag = finalAttrs.version;
    hash = "sha256-iKLO0m9zPYGQB3aJxyYCs9sHSheihnKn8QWec4D+a4g=";
  };

  vendorHash = "sha256-X2vrEhgEnKKNXRyLCtT+wBbunFHgkcyWZh6DMpQieQ0=";

  ldflags = [
    # make sure build time is always set to 0 to make the build reproducible
    "-X github.com/mtlynch/picoshare/v2/build.unixTime=0"
    # the app displays the version in the "system > information" menu
    "-X github.com/mtlynch/picoshare/v2/build.Version=${finalAttrs.version}"
  ];

  buildInputs = lib.optional litestreamSupport litestream;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Minimalist, easy-to-host service for sharing images and other files";
    homepage = "https://github.com/mtlynch/picoshare";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "picoshare";
    maintainers = with lib.maintainers; [
      blokyk
    ];
  };
})
