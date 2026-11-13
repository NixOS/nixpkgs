{
  lib,
  fetchFromGitHub,
  crystal,
  gobject-introspection,
  gitUpdater,
}:
crystal.buildCrystalPackage rec {
  pname = "gi-crystal";
  version = "0.26.0";

  src = fetchFromGitHub {
    owner = "hugopl";
    repo = "gi-crystal";
    rev = "v${version}";
    hash = "sha256-/N4byXwWTKvqcXcABrvN2ei2ExQqgoMhbTZr7wHvw7E=";
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

  meta = {
    description = "GI Crystal is a binding generator used to generate Crystal bindings for GObject based libraries using GObject Introspection";
    homepage = "https://github.com/hugopl/gi-crystal";
    mainProgram = "gi-crystal";
    maintainers = with lib.maintainers; [ sund3RRR ];
    license = lib.licenses.bsd3;
  };
}
