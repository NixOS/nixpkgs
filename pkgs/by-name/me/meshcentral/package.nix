{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  fetchpatch,
}:

buildNpmPackage (finalAttrs: {
  pname = "meshcentral";
  version = "1.1.56";

  src = fetchFromGitHub {
    owner = "Ylianst";
    repo = "MeshCentral";
    tag = finalAttrs.version;
    hash = "sha256-tISK6EmWCIDEkUB6CpIW3+eH2JyTam5URlhYpSkGsrw=";
  };

  npmDepsHash = "sha256-Etpf964Rb4fOty7RdyClQelyLMLVJhSQQB4fLgnf6AE=";

  patches = [
    ./fix-js-include-paths.patch
    # from some reason the way the package is installed causes the `require`
    # line in `$out/lib/node_modules/meshcentral/bin/meshcentral` to import the
    # main file as a module, and thus nothing happens when it runs. We remove
    # this conditional since we never use this as a module.
    ./run.patch
    # Bring back package.json. See: https://github.com/Ylianst/MeshCentral/issues/7643
    (fetchpatch {
      url = "https://github.com/Ylianst/MeshCentral/commit/a5d27530eac148c8671bc502bbcdb21efb512079.patch";
      hash = "sha256-jmH2eVIRhZZ0sElU0o5yhSzVeItNdw4B5mnzGBiFFXM=";
    })
  ];

  dontNpmBuild = true;

  meta = {
    description = "Computer management web app";
    homepage = "https://meshcentral.com/";
    maintainers = with lib.maintainers; [ ma27 ];
    license = lib.licenses.asl20;
    mainProgram = "meshcentral";
  };
})
