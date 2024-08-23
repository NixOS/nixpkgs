{ lib
, fetchFromGitHub
, stdenvNoCC
, makeWrapper
, gh
, fzf
, coreutils
, gawk
, gnused
, withBat ? false
, bat
}:
let
  binPath = lib.makeBinPath ([
    gh
    fzf
    coreutils
    gawk
    gnused
  ]
  ++ lib.optional withBat bat);
in
stdenvNoCC.mkDerivation rec {
  pname = "gh-f";
  version = "1.1.6";

  src = fetchFromGitHub {
    owner = "gennaro-tedesco";
    repo = "gh-f";
    rev = "v${version}";
    hash = "sha256-F98CqsSRymL/8s8u7P2Pqt6+ipLoG9Z9Q8bB+IWZTpI=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  installPhase = ''
    install -D -m755 "gh-f" "$out/bin/gh-f"
  '';

  postFixup = ''
    wrapProgram "$out/bin/gh-f" --prefix PATH : "${binPath}"
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
