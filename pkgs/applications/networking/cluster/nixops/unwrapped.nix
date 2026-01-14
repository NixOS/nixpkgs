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
  version = "2.0.0-unstable-2025-12-28";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "NixOS";
    repo = "nixops";
    rev = "fd4b8031dbaf753545188b7c380194e47604dbac";
    hash = "sha256-BYCCULov1/Mu5Tp4N1voQFPVWsWVyKhlQoH+I7IJnuE=";
  };

  postPatch = ''
    substituteInPlace nixops/args.py --replace-fail "@version@" "${version}-pre-${
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

  meta = {
    description = "Tool for deploying to NixOS machines in a network or cloud";
    homepage = "https://github.com/NixOS/nixops";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [
      aminechikhaoui
      roberth
    ];
    platforms = lib.platforms.unix;
    mainProgram = "nixops";
  };
}
