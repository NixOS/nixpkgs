{
  lib,
  fetchPypi,
  fetchFromGitHub,
  python3,
  openssl,

  withE2BE ? true,
}:

let
  # tulir-telethon is a fork of telethon used only by mautrix-telegram. It is
  # built standalone rather than via telethon.overrideAttrs so it does not
  # inherit telethon's `disabled = pythonAtLeast "3.14"` (which exists only
  # because telethon's *tests* fail on 3.14). This fork skips the test suite.
  #
  # Kept as a local let binding rather than a top-level package: the upstream
  # Python version is EOL (being rewritten in Go), so splitting it out would
  # only add maintenance surface for code that will soon be replaced.
  tulir-telethon = python3.pkgs.buildPythonPackage {
    pname = "tulir_telethon";
    version = "1.99.0a6";
    pyproject = true;
    src = fetchFromGitHub {
      owner = "tulir";
      repo = "Telethon";
      tag = "v1.99.0a6";
      hash = "sha256-ulnA+xKbZDOTzXYmF9oBWNBNhgxSiF+mKx1ijoCyo/w=";
    };
    postPatch = ''
      substituteInPlace telethon/crypto/libssl.py --replace-fail \
        "ctypes.util.find_library('ssl')" "'${lib.getLib openssl}/lib/libssl.so'"
    '';
    build-system = [
      python3.pkgs.setuptools
    ];
    dependencies = with python3.pkgs; [
      pyaes
      rsa
    ];
    dontUsePytestCheck = true;
  };
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

  patches = [
    ./0001-Re-add-entrypoint.patch
    ./0002-use-importlib-resources.patch
  ];

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
