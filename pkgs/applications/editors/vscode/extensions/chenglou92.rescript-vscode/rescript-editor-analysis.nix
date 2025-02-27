{
  lib,
  fetchFromGitHub,
  ocamlPackages,
  version,
}:

ocamlPackages.buildDunePackage rec {
  inherit version;

  pname = "analysis";

  minimalOCamlVersion = "4.10";

  src = fetchFromGitHub {
    owner = "rescript-lang";
    repo = "rescript-vscode";
    rev = version;
    hash = "sha256-v+qCVge57wvA97mtzbxAX9Fvi7ruo6ZyIC14O8uWl9Y=";
  };

  nativeBuildInputs = [
    ocamlPackages.cppo
  ];

  meta = with lib; {
    description = "Analysis binary for the ReScript VSCode plugin";
    homepage = "https://github.com/rescript-lang/rescript-vscode";
    maintainers = [
      maintainers.dlip
      maintainers.jayesh-bhoot
    ];
    license = licenses.mit;
  };
}
