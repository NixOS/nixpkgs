{
  lib,
  fetchPypi,
  fetchFromGitHub,
  python3,

  withE2BE ? true,
}:

let
  tulir-telethon = python3.pkgs.telethon.overrideAttrs (
    finalAttrs: previousAttrs: {
      version = "1.99.0a6";
      pname = "tulir_telethon";
      src = fetchFromGitHub {
        owner = "tulir";
        repo = "Telethon";
        tag = "v${finalAttrs.version}";
        hash = "sha256-ulnA+xKbZDOTzXYmF9oBWNBNhgxSiF+mKx1ijoCyo/w=";
      };
      dontUsePytestCheck = true;
    }
  );
in
python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "mautrix-telegram";
  version = "0.15.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "telegram";
    tag = "v${finalAttrs.version}";
    hash = "sha256-w3BqWyAJV/lZPoOFDzxhootpw451lYruwM9efwS6cEc=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  patches = [ ./0001-Re-add-entrypoint.patch ];

  pythonRelaxDeps = [
    "mautrix"
    "ruamel.yaml"
  ];

  dependencies =
    with python3.pkgs;
    [
      ruamel-yaml
      python-magic
      commonmark
      aiohttp
      yarl
      (mautrix.override { withOlm = withE2BE; })
      tulir-telethon
      asyncpg
      mako
      setuptools
      # speedups
      cryptg
      aiodns
      brotli
      # qr_login
      pillow
      qrcode
      # formattednumbers
      phonenumbers
      # metrics
      prometheus-client
      # sqlite
      aiosqlite
      # proxy support
      pysocks
    ]
    ++ lib.optionals withE2BE [
      # e2be
      python-olm
      pycryptodome
      unpaddedbase64
    ];

  # has no tests
  doCheck = false;

  meta = {
    homepage = "https://github.com/mautrix/telegram";
    description = "Matrix-Telegram hybrid puppeting/relaybot bridge";
    license = lib.licenses.agpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      nyanloutre
      nickcao
    ];
    mainProgram = "mautrix-telegram";
  };
})
