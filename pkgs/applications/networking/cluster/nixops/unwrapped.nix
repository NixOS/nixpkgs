{ lib
, buildPythonApplication
, fetchFromGitHub
, unstableGitUpdater
, poetry-core
, sphinx
, pluggy
, prettytable
, typeguard
, typing-extensions
, nixosTests
}:

buildPythonApplication rec {
  pname = "nixops";
  version = "unstable-2023-10-26";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "NixOS";
    repo = "nixops";
    rev = "2cfc2cb4fa9ecb89a4274574ff7f63ea61782498";
    hash = "sha256-4uvQQkERZFEeRJjMAcyLYJzNvH0rNiiJ+5BDQmD58gI=";
  };

  postPatch = ''
    substituteInPlace nixops/args.py --replace "@version@" "${version}-pre-${lib.substring 0 7 src.rev or "dirty"}"
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
    tests.nixops = nixosTests.nixops.unstable;
    updateScript = unstableGitUpdater {};
  };

  meta = with lib; {
    description = "A tool for deploying to NixOS machines in a network or cloud";
    homepage = "https://github.com/NixOS/nixops";
    license = licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ aminechikhaoui roberth ];
    platforms = lib.platforms.unix;
    mainProgram = "nixops";
  };
}
