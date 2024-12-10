{
  lib,
  buildPythonApplication,
  fetchFromGitHub,
  unstableGitUpdater,
  poetry-core,
  sphinx,
  pluggy,
  prettytable,
  typeguard,
  typing-extensions,
  nixosTests,
}:

buildPythonApplication rec {
  pname = "nixops";
  version = "1.7-unstable-2024-02-28";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "NixOS";
    repo = "nixops";
    rev = "08feccb14074c5434f3e483d19a7f7d9bfcdb669";
    hash = "sha256-yWeF5apQJdChjYVSOyH6LYjJYGa1RL68LRHrSgZ9l8U=";
  };

  postPatch = ''
    substituteInPlace nixops/args.py --replace "@version@" "${version}-pre-${
      lib.substring 0 7 src.rev or "dirty"
    }"
  '';

  nativeBuildInputs = [
    poetry-core
    sphinx
  ];

  propagatedBuildInputs = [
    pluggy
    prettytable
    typeguard
    typing-extensions
  ];

  postInstall = ''
    doc_cache=$(mktemp -d)
    sphinx-build -b man -d $doc_cache doc/ $out/share/man/man1

    html=$(mktemp -d)
    sphinx-build -b html -d $doc_cache doc/ $out/share/nixops/doc
  '';

  pythonImportsCheck = [ "nixops" ];

  passthru = {
    tests.nixos = nixosTests.nixops.unstable;
    updateScript = unstableGitUpdater {
      tagPrefix = "v";
    };
  };

  meta = with lib; {
    description = "A tool for deploying to NixOS machines in a network or cloud";
    homepage = "https://github.com/NixOS/nixops";
    license = licenses.lgpl3Only;
    maintainers = with lib.maintainers; [
      aminechikhaoui
      roberth
    ];
    platforms = lib.platforms.unix;
    mainProgram = "nixops";
  };
}
