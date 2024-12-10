{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  makeWrapper,
  gh,
  gnugrep,
  fzf,
  python3,
  withDelta ? false,
  delta,
  withBat ? false,
  bat,
}:
let
  binPath = lib.makeBinPath (
    [
      gh
      gnugrep
      fzf
      python3
    ]
    ++ lib.optional withBat bat
    ++ lib.optional withDelta delta
  );
in
stdenvNoCC.mkDerivation {
  pname = "gh-notify";
  version = "0-unstable-2024-04-24";

  src = fetchFromGitHub {
    owner = "meiji163";
    repo = "gh-notify";
    rev = "5c2db4cffe39f312d25979dc366f2bc219def9a2";
    hash = "sha256-AgpNjeRz0RHf8D3ib7x1zixBxh32UUZJleub5W/suuM=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  installPhase = ''
    install -D -m755 "gh-notify" "$out/bin/gh-notify"
  '';

  postFixup = ''
    wrapProgram "$out/bin/gh-notify" --prefix PATH : "${binPath}"
  '';

  meta = with lib; {
    homepage = "https://github.com/meiji163/gh-notify";
    description = "GitHub CLI extension to display GitHub notifications";
    maintainers = with maintainers; [ loicreynier ];
    license = licenses.unlicense;
    mainProgram = "gh-notify";
    platforms = platforms.all;
  };
}
