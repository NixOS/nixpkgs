{
  lib,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "fiduswriter";
  version = "4.1.10";
  format = "setuptools"; # TODO: switch to pyproject when setuptools>=82.0.1
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "fiduswriter";
    repo = "fiduswriter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NkFJehSgwYwYUZaznZW63KEXR1wTf+Hpa+8ZM71aZ84=";
  };

  build-system = with python3Packages; [
    babel
    setuptools
  ];

  optional-dependencies = with python3Packages; {
    books = [
      fiduswriter-books
    ];
    citation-api-import = [
      fiduswriter-citation-api-import
    ];
    gitrepo-export = [
      fiduswriter-gitrepo-export
    ];
    languagetool = [
      fiduswriter-languagetool
    ];
    mysql = [
      mysqlclient
    ];
    ojs = [
      fiduswriter-ojs
    ];
    orjson = [
      orjson
    ];
    pandoc = [
      fiduswriter-pandoc
    ];
    payment-paddle = [
      fiduswriter-payment-paddle
    ];
    phplist = [
      fiduswriter-phplist
    ];
    postgresql = [
      psycopg2
    ];
    prosemirror-python = [
      prosemirror
    ];
    prosemirror-rust = [
      prosemirror-rs
    ];
    website = [
      fiduswriter-website
    ];
  };

  pythonImportsCheck = [
    "fiduswriter"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fidus Writer is an online collaborative editor for academics";
    homepage = "https://github.com/fiduswriter/fiduswriter";
    changelog = "https://github.com/fiduswriter/fiduswriter/releases/tag/${finalAttrs.src.tag}";
    mainProgram = "fiduswriter";
    license = with lib.licenses; [ agpl3Only ];
    maintainers = with lib.maintainers; [ eljamm ];
    teams = with lib.teams; [ ngi ];
  };
})
