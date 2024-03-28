{ lib
, fetchFromGitHub
, stdenv
, fzf
, python3
}:

stdenv.mkDerivation {
  pname = "gh-notify";
  version = "unstable-2024-03-19";

  src = fetchFromGitHub {
    owner = "meiji163";
    repo = "gh-notify";
    rev = "0d8fa377d79cfef0f66d2f03a5921a5e598e6807";
    hash = "sha256-Ao6gUtgW7enVlWBQhlQDc8ZW/gP90atc2F4rDNUnjj8=";
  };

  propagatedBuildInputs = [
    fzf
    python3
  ];

  installPhase = ''
    install -D -m744 "gh-notify" "$out/bin/gh-notify"
  '';

  meta = with lib; {
    homepage = "https://github.com/meiji163/gh-notify";
    description = "GitHub CLI extension to display GitHub notifications";
    maintainers = with maintainers; [ loicreynier ];
    license = licenses.unlicense;
  };
}
