{
  lib,
  fetchFromGitLab,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "hash-identifier";
  version = "1.2";

  src = fetchFromGitLab {
    owner = "kalilinux";
    repo = "packages/hash-identifier";
    rev = "kali/${finalAttrs.version}+git20180314-0kali1";
    hash = "sha256-UAw5JC9bUORfqsQ/pacoV1xvnRu21WceY1NKLiMiv6o=";
  };

  pyproject = false; # no setup.py

  installPhase = ''
    install -Dm0775 hash-id.py $out/bin/hash-identifier
  '';

  meta = {
    description = "Identify the different types of hashes used to encrypt data and especially passwords";
    homepage = "https://github.com/blackploit/hash-identifier";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ ethancedwards8 ];
    mainProgram = "hash-identifier";
  };
})
