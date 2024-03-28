{ lib
, fetchFromGitHub
, stdenv
, fzf
, coreutils
, bat
}:

stdenv.mkDerivation rec {
  pname = "gh-f";
  version = "1.1.5";

  src = fetchFromGitHub {
    owner = "gennaro-tedesco";
    repo = "gh-f";
    rev = "v${version}";
    hash = "sha256-ITl8T8Oe21m047ygFlxWVjzUYPG4rlcTjfSpsropYJw=";
  };

  propagatedBuildInputs = [
    fzf
    bat
    coreutils
  ];

  installPhase = ''
    install -D -m744 "gh-f" "$out/bin/gh-f"
  '';

  meta = with lib; {
    homepage = "https://github.com/gennaro-tedesco/gh-f";
    description = "GitHub CLI ultimate FZF extension";
    maintainers = with maintainers; [ loicreynier ];
    license = licenses.unlicense;
  };
}

