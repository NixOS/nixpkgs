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

stdenv.mkDerivation rec {
  pname = "re2c";
<<<<<<< HEAD
  version = "4.3.1";
=======
  version = "4.3";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "skvadrik";
    repo = "re2c";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-ihtAB6HLgYhX+FKPFy01RByy/M468YrHv2v5wB9bJws=";
=======
    hash = "sha256-zPOENMfXXgTwds1t+Lrmz9+GTHJf2yRpQsGT7nLRvcg=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "Tool for writing very fast and very flexible scanners";
    homepage = "https://re2c.org";
    license = lib.licenses.publicDomain;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ thoughtpolice ];
=======
  meta = with lib; {
    description = "Tool for writing very fast and very flexible scanners";
    homepage = "https://re2c.org";
    license = licenses.publicDomain;
    platforms = platforms.all;
    maintainers = with maintainers; [ thoughtpolice ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
