{
  lib,
  fetchFromGitHub,
  crystal,
  gobject-introspection,
  gitUpdater,
}:
crystal.buildCrystalPackage rec {
  pname = "gi-crystal";
  version = "0.25.1";

  src = fetchFromGitHub {
    owner = "hugopl";
    repo = "gi-crystal";
    rev = "v${version}";
    hash = "sha256-+sc36YjaVKBkrg8Ond4hCZoObnSHIU/jyMRalZ+OAwk=";
  };

  patches = [
    ./src.patch
  ];

  nativeBuildInputs = [ gobject-introspection ];
  buildTargets = [ "generator" ];

  doCheck = false;
  doInstallCheck = false;

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -r * $out

    runHook postInstall
  '';

  passthru = {
    updateScript = gitUpdater { rev-prefix = "v"; };
  };

  meta = with lib; {
    description = "GI Crystal is a binding generator used to generate Crystal bindings for GObject based libraries using GObject Introspection";
    homepage = "https://github.com/hugopl/gi-crystal";
    mainProgram = "gi-crystal";
    maintainers = with maintainers; [ sund3RRR ];
  };
}
