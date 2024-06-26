{
  lib,
  buildNpmPackage,
  fetchurl,
}:

buildNpmPackage rec {
  pname = "nadesiko3";
  version = "3.6.7";

  src = fetchurl {
    url = "https://registry.npmjs.org/nadesiko3/-/nadesiko3-${version}.tgz";
    hash = "sha256-Y9kJErYwFgGCpL5uhXKOUmpheI2cwC4Rt5uHqoFIhTc=";
  };

  npmDepsHash = "sha256-9HGoX+0xzw6ukrR4umCU+Gk9InmKgJ2CztASgD2kXdo=";

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
