{
  lib,
  buildNpmPackage,
  fetchurl,
}:

buildNpmPackage rec {
  pname = "nadesiko3";
  version = "3.6.22";

  src = fetchurl {
    url = "https://registry.npmjs.org/nadesiko3/-/nadesiko3-${version}.tgz";
    hash = "sha256-0I1FBs+4Za1n+E49R58NS8XZM1/JD1I7/QGHXpl39qM=";
  };

  npmDepsHash = "sha256-odGCIHp+qr7S3BBam0yFIRzZr4RzrrtwhgydLVyRPuE=";

  postPatch = ''
    ln -s ${./package-lock.json} package-lock.json
  '';

  dontNpmBuild = true;

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Japanese Programming Language Nadesiko v3 (JavaScript/TypeScript)";
    homepage = "https://nadesi.com";
    license = lib.licenses.mit;
    mainProgram = "cnako3";
    maintainers = with lib.maintainers; [ donovanglover ];
  };
}
