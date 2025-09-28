{
  lib,
  python3Packages,
  fetchPypi,
  fetchpatch2,
  nixosTests,
}:

python3Packages.buildPythonApplication rec {
  pname = "rss2email";
  version = "3.14";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-RwORS2PHquxBZLNKqCJtR5XX4SHqPCb/Fn+Y68dfI/g=";
  };

  patches = [
    (fetchpatch2 {
      name = "html2text-2024.2.25-compat.patch";
      url = "https://github.com/rss2email/rss2email/commit/b5c0e78006c2db6929b5ff50e8529de58a00412a.patch";
      hash = "sha256-edmsi3I0acx5iF9xoAS9deSexqW2UtWZR/L7CgeZs/M=";
    })
    # https://github.com/rss2email/rss2email/pull/279
    ./html2text-2025.4.15-compat.patch
    (fetchpatch2 {
      name = "use-poetry-core.patch";
      url = "https://github.com/rss2email/rss2email/commit/183a17aefe4eb66f898cf088519b1e845559f2bd.patch";
      hash = "sha256-SoWahlOJ7KkaHMwOrKIBgwEz8zJQrSXVD1w2wiV1phE=";
    })
  ];

  outputs = [
    "out"
    "man"
    "doc"
  ];

  postPatch = ''
    # sendmail executable is called from PATH instead of sbin by default
    substituteInPlace  rss2email/config.py \
      --replace-fail '/usr/sbin/sendmail' 'sendmail'
  '';

  build-system = with python3Packages; [
    poetry-core
  ];

  dependencies = with python3Packages; [
    feedparser
    html2text
  ];

  postInstall = ''
    install -Dm 644 r2e.1 $man/share/man/man1/r2e.1
    # an alias for better finding the manpage
    ln -s -T r2e.1 $man/share/man/man1/rss2email.1

    # copy documentation
    mkdir -p $doc/share/doc/rss2email
    cp AUTHORS COPYING CHANGELOG README.rst $doc/share/doc/rss2email/
  '';

  nativeCheckInputs = [
    python3Packages.unittestCheckHook
  ];

  unittestFlagsArray = [
    "-s"
    "test"
  ];

  meta = with lib; {
    description = "Tool that converts RSS/Atom newsfeeds to email";
    homepage = "https://pypi.python.org/pypi/rss2email";
    license = licenses.gpl2;
    maintainers = with maintainers; [ ekleog ];
    mainProgram = "r2e";
  };
  passthru.tests = {
    smoke-test = nixosTests.rss2email;
  };
}
