# <https://github.com/TooTallNate/node-bindings>
{ buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "node-bindings";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "TooTallNate";
    repo = pname;
    rev = version;
    hash = "sha256-kx8ia5rQyyOKxwkHk8+vpWMYslwaXItbkKRteae5D4A=";
  };

  prePatch = ''
    substituteAll ${./package-lock.json} package-lock.json
  '';

  postInstall = ''
    cp package-lock.json $out/lib/node_modules/bindings/
  '';

  dontNpmBuild = true;
  npmDepsHash = "sha256-MMIm0ps6J/E1WaPdwAWn4vYEbbf5F9c+/goS7FGB8YQ=";
}
