{
  lib,
  fetchFromGitHub,
  ocamlPackages,
  version,
}:

ocamlPackages.buildDunePackage rec {
  pname = "analysis";
  inherit version;

  minimalOCamlVersion = "4.10";

  src = fetchFromGitHub {
    owner = "rescript-lang";
    repo = "rescript-vscode";
    rev = version;
    hash = "sha256-v+qCVge57wvA97mtzbxAX9Fvi7ruo6ZyIC14O8uWl9Y=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    ocamlPackages.cppo
  ];

  meta = {
    description = "Analysis binary for the ReScript VSCode plugin";
    homepage = "https://github.com/rescript-lang/rescript-vscode";
    maintainers = [
      lib.maintainers.dlip
      lib.maintainers.jayesh-bhoot
    ];
    license = lib.licenses.mit;
    mainProgram = "rescript-editor-analysis";
  };
}
