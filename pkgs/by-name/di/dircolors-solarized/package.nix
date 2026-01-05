{
  fetchFromGitHub,
  lib,
  stdenv,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "dircolors-solarized";
  version = "0-unstable-2025-09-22";

  src = fetchFromGitHub {
    owner = "seebi";
    repo = "dircolors-solarized";
    rev = "38971d217512a23391139fcee2a520eba7cddf37";
    hash = "sha256-UlSbg3njsVV7+Dlu5CXAmz7BcyihDIVwiWFzV157RSw=";
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
