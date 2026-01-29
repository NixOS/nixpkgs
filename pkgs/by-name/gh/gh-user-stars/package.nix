{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  pkgs,
}:

stdenvNoCC.mkDerivation {
  pname = "gh-user-stars";
  version = "0-unstable-2021-11-15";

  src = fetchFromGitHub {
    owner = "korosuke613";
    repo = "gh-user-stars";
    rev = "1829ccdb28159e4924a22e533a5d8b81698dc218";
    hash = "sha256-lXuoBbxd6bViMXpSiDxOoGuLCzrk2YmRotIBjKxmWrA=";
  };

  propagatedBuildInput = with pkgs; [
    fzf
    gh
    jq
  ];

  installPhase = ''
    runHook preInstall

    install -Dm644 $src/libs.sh $out/share/gh-user-stars/libs.sh
    install -Dm755 $src/gh-user-stars $out/bin/gh-user-stars
    substituteInPlace $out/bin/gh-user-stars \
        --replace-fail libs.sh ../share/gh-user-stars/libs.sh \
        --replace-fail \''${extensionPath}/pid /tmp/gh-user-stars-pid

    runHook postInstall
  '';

  meta = {
    description = "Displays an interactive and searchable list of your GitHub starred repositories";
    homepage = "https://github.com/korosuke613/gh-user-stars";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ starsep ];
    mainProgram = "gh-user-stars";
  };
}
