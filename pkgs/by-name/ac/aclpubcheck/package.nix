{
  lib,
  python3Packages,
  fetchFromGitHub,
  callPackage,
}:

python3Packages.buildPythonApplication {
  pname = "aclpubcheck";
  version = "0.2.0-unstable-2026-09-11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "acl-org";
    repo = "aclpubcheck";
    rev = "237bee3a554f2d2fcda69cd0cf1edf4168e3d339"; # No Git Tags
    hash = "sha256-s9kegTZOZEgGx0Yj8jOfzAyjyy1EuabOybMDBoodRvo=";
  };

  strictDeps = true;
  __structuredAttrs = true;

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

  meta = {
    description = "Tool for checking ACL paper submissions";
    homepage = "https://github.com/acl-org/aclpubcheck";
    license = with lib.licenses; [ mit ];
    mainProgram = "aclpubcheck";
    maintainers = with lib.maintainers; [ Luflosi ];
  };
}
