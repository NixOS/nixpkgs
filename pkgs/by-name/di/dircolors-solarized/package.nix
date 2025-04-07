{
  fetchFromGitHub,
  lib,
  stdenv,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "dircolors-solarized";
  version = "0-unstable-2025-02-03";

  src = fetchFromGitHub {
    owner = "seebi";
    repo = "dircolors-solarized";
    rev = "52bfa164e4388ee232f6a9235f62e8482e1f1767";
    hash = "sha256-+2t9OsyD9QkamsFbgmgehBrfszBQmv1Y0C94T4g16GI=";
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
