{
  lib,
  buildNpmPackage,
  fetchurl,
}:

buildNpmPackage rec {
  pname = "nadesiko3";
  version = "3.6.12";

  src = fetchurl {
    url = "https://registry.npmjs.org/nadesiko3/-/nadesiko3-${version}.tgz";
    hash = "sha256-X6m3haNRmfUEweInbGj5Vr4BYW+xzABJNCIRrp5tHZQ=";
  };

  npmDepsHash = "sha256-lgz3FES23C5cBXcWNwEvks+8uyWdnstNYWufewKO4oc=";

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
