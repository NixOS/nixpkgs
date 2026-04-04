{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  autoreconfHook,
  nix-update-script,
  python3,

  # for passthru.tests
  ninja,
  php,
  spamassassin,
}:

stdenv.mkDerivation rec {
  pname = "re2c";
  version = "4.3.1";

  src = fetchFromGitHub {
    owner = "skvadrik";
    repo = "re2c";
    rev = version;
    hash = "sha256-ihtAB6HLgYhX+FKPFy01RByy/M468YrHv2v5wB9bJws=";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2026-2903.patch";
      url = "https://github.com/skvadrik/re2c/commit/febeb977936f9519a25d9fbd10ff8256358cdb97.patch";
      hash = "sha256-JqnGfK48wpbWHb3aD9Fj3DOyoqHpbjvowppY/Vg5YWA=";
    })
  ];

  nativeBuildInputs = [
    autoreconfHook
    python3
  ];

  doCheck = true;
  enableParallelBuilding = true;

  preCheck = ''
    patchShebangs run_tests.py
  '';

  passthru = {
    updateScript = nix-update-script {
      # Skip non-release tags like `python-experimental`.
      extraArgs = [
        "--version-regex"
        "([0-9.]+)"
      ];
    };
    tests = {
      inherit ninja php spamassassin;
    };
  };

  meta = {
    description = "Tool for writing very fast and very flexible scanners";
    homepage = "https://re2c.org";
    license = lib.licenses.publicDomain;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ thoughtpolice ];
  };
}
