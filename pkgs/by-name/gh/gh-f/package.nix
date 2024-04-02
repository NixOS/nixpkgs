{ lib
, fetchFromGitHub
, stdenvNoCC
, makeWrapper
, fzf
, coreutils
, bat
}:

stdenvNoCC.mkDerivation rec {
  pname = "gh-f";
  version = "1.1.5";

  src = fetchFromGitHub {
    owner = "gennaro-tedesco";
    repo = "gh-f";
    rev = "v${version}";
    hash = "sha256-ITl8T8Oe21m047ygFlxWVjzUYPG4rlcTjfSpsropYJw=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  installPhase = ''
    install -D -m755 "gh-f" "$out/bin/gh-f"
  '';

  postFixup = ''
    wrapProgram "$out/bin/gh-f" --prefix PATH : "${lib.makeBinPath [fzf bat coreutils]}"
  '';

  meta = with lib; {
    homepage = "https://github.com/gennaro-tedesco/gh-f";
    description = "GitHub CLI ultimate FZF extension";
    maintainers = with maintainers; [ loicreynier ];
    license = licenses.unlicense;
    mainProgram = "gh-f";
    platforms = platforms.all;
  };
}
