{
  lib,
  fetchFromGitLab,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "hash-identifier";
  version = "1.2";

  src = fetchFromGitLab {
    owner = "kalilinux";
    repo = "packages/hash-identifier";
    rev = "kali/${version}+git20180314-0kali1";
    sha256 = "1amz48ijwjjkccg6gmdn3ffnyp2p52ksagy4m9gy8l2v5wj3j32h";
  };

  format = "other"; # no setup.py

  installPhase = ''
    install -Dm0775 hash-id.py $out/bin/hash-identifier
  '';

  meta = with lib; {
    description = "Identify the different types of hashes used to encrypt data and especially passwords";
    homepage = "https://github.com/blackploit/hash-identifier";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ethancedwards8 ];
    mainProgram = "hash-identifier";
  };
}
