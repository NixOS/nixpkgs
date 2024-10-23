{
  lib,
  buildNpmPackage,
  fetchzip,
}:

buildNpmPackage rec {
  pname = "manicode";
  version = "1.0.90";

  src = fetchzip {
    url = "https://registry.npmjs.org/${pname}/-/${pname}-${version}.tgz";
    hash = "sha256-eqdCwxEqTiKEp+VTwxOe7nODbhjx38MwXRp4RXZK/WA=";
  };

  npmDepsHash = "sha256-xLN5ZsUd6C8/bWoJG0OgcI5sabdBvR1zYi4hPOlqAKo=";

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  dontNpmBuild = true;

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Use natural language to edit your codebase and run commands from your terminal faster";
    homepage = "https://manicode.ai";
    downloadPage = "https://www.npmjs.com/package/manicode";
    license = licenses.mit;
    maintainers = [ maintainers.malo ];
  };
}
