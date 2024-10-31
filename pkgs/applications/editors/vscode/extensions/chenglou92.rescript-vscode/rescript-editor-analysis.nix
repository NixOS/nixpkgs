{
  lib,
  stdenv,
  fetchFromGitHub,
  ocaml,
  ocamlPackages,
  dune_3,
  version,
}:

stdenv.mkDerivation {
  pname = "rescript-editor-analysis";
  inherit version;

  src = fetchFromGitHub {
    owner = "rescript-lang";
    repo = "rescript-vscode";
    rev = version;
    hash = "sha256-v+qCVge57wvA97mtzbxAX9Fvi7ruo6ZyIC14O8uWl9Y=";
  };

  nativeBuildInputs = [
    ocaml
    dune_3
    ocamlPackages.cppo
  ];

  buildPhase = ''
    dune build -p analysis
  '';

  installPhase = ''
    install -D -m0555 _build/default/analysis/bin/main.exe $out/bin/rescript-editor-analysis.exe
  '';

  meta = {
    description = "Analysis binary for the ReScript VSCode plugin";
    homepage = "https://github.com/rescript-lang/rescript-vscode";
    maintainers = [
      lib.maintainers.dlip
      lib.maintainers.jayesh-bhoot
    ];
    license = lib.licenses.mit;
  };
}
