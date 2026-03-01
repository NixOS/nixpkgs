{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "meshcentral";
  version = "1.1.57";

  src = fetchFromGitHub {
    owner = "Ylianst";
    repo = "MeshCentral";
    tag = finalAttrs.version;
    hash = "sha256-tXv4AWFLBoaHraSTYbEuNjdxnB3tYyAYq5xPe4jRcmw=";
  };

  npmDepsHash = "sha256-Etpf964Rb4fOty7RdyClQelyLMLVJhSQQB4fLgnf6AE=";

  patches = [
    ./fix-js-include-paths.patch
    # from some reason the way the package is installed causes the `require`
    # line in `$out/lib/node_modules/meshcentral/bin/meshcentral` to import the
    # main file as a module, and thus nothing happens when it runs. We remove
    # this conditional since we never use this as a module.
    ./run.patch
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
