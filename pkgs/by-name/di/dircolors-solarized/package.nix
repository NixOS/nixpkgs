{
  fetchFromGitHub,
  lib,
  stdenv,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "dircolors-solarized";
  version = "0-unstable-2025-08-01";

  src = fetchFromGitHub {
    owner = "seebi";
    repo = "dircolors-solarized";
    rev = "13c1af03d398f46957e22cec6b001e5663ed473e";
    hash = "sha256-abaFq/8+UAQLfbzCuFH2uglN8ugafTp2Evk4+dchylo=";
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
