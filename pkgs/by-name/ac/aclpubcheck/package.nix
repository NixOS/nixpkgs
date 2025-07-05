{
  lib,
  python3Packages,
  fetchFromGitHub,
  callPackage,
}:

python3Packages.buildPythonApplication {
  pname = "aclpubcheck";
  version = "0.2.0-unstable-2025-05-16";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "acl-org";
    repo = "aclpubcheck";
    rev = "a340fc0a1a7d1c9808f08ab1dab1d228f63af405"; # No Git Tags
    hash = "sha256-yj+EX+oL2WgsPJePrJQgRAIYWPEodDmG+GDG0K2gjhs=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    tqdm
    termcolor
    pandas
    pdfplumber
    rebiber
    pybtex
    pylatexenc
    unidecode
    tsv
  ];

  passthru.tests = {
    example-pdf = callPackage ./test { };
  };

  strictDeps = true;

  meta = {
    description = "Tool for checking ACL paper submissions";
    homepage = "https://github.com/acl-org/aclpubcheck";
    license = with lib.licenses; [ mit ];
    mainProgram = "aclpubcheck";
    maintainers = with lib.maintainers; [ Luflosi ];
  };
}
