{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  nix-update-script,
  python3,

  # for passthru.tests
  ninja,
  php,
  spamassassin,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "re2c";
  version = "4.5.1";

  src = fetchFromGitHub {
    owner = "skvadrik";
    repo = "re2c";
    rev = finalAttrs.version;
    hash = "sha256-POdE8aKvQqfIPEIkUppZPV8t9ApT4R1AyfHXxrKvq88=";
  };

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
})
