{
  fetchFromGitHub,
  lib,
  stdenv,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "dircolors-solarized";
  version = "0-unstable-2026-05-27";

  src = fetchFromGitHub {
    owner = "seebi";
    repo = "dircolors-solarized";
    rev = "bd9d473393a78366d5c3658d9cd2db7d8944b447";
    hash = "sha256-2uZ2vpnMyoWk1TdHE6sbUGXhw1zTwfbk2KRIma6F5DA=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    for f in dircolors.*; do
      install -Dm644 $f $out/''${f#dircolors.}
    done

    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Repository of themes for GNU, supporting Solarized color scheme";
    homepage = "https://github.com/seebi/dircolors-solarized";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ polyfloyd ];
  };
}
