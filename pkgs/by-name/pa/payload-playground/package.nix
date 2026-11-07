{
  buildNpmPackage,
  fetchzip,
  lib,

}:

buildNpmPackage {
  pname = "payload-playground";
  version = "1.5.0";

  src = fetchzip {
    url = "https://registry.npmjs.org/payload-playground/-/payload-playground-1.5.0.tgz";
    sha256 = "sha256-sEbBeVrQC/B2lR6pFqYJjZ5GSnnMbvA4qSx8yCBPS8Y=";
  };

  npmFlags = [ "--ignore-scripts" ];
  npmPackFlags = [ "--ignore-scripts" ];
  npmRebuildFlags = [ ];

  postPatch = ''
    ln -s ${./package-lock.json} ./package-lock.json
  '';

  NODE_OPTIONS = "--openssl-legacy-provider";
  dontNpmBuild = true;

  npmDepsHash = "sha256-Gp+JQ7uNaugUza5wtpfZHOkkTzzb7JyLOBy5YhPQxfs=";

  __structuredAttrs = true; # RFC 140

  meta = {
    description = "The most complete penetration testing toolkit in a single command.";
    longDescription = "51 commands. Zero dependencies beyond Node.js. Pipe-friendly. TTY-aware.
    From recon to exploitation to reporting — without leaving your terminal.";
    homepage = "https://payloadplayground.com";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Darks1de42 ];
    mainProgram = "payload";
  };
}
