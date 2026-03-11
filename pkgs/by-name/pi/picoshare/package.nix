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
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "mtlynch";
    repo = "picoshare";
    tag = finalAttrs.version;
    hash = "sha256-8mgrwnY0Y1CggAtc7BrAqC32+Wu82FQNhoK0ijM1RKw=";
  };

  vendorHash = "sha256-Wf0qKs/9XKnO2nx2KmTGPdqI0iFih30AGvOi94RPEjw=";

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
