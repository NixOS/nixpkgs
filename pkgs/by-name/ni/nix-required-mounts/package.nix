{ addOpenGLRunpath
, cmake
, allowedPatterns ? rec {
    opengl.onFeatures = [ "opengl" ];
    opengl.paths = [
      addOpenGLRunpath.driverLink
      "/dev/video*"
      "/dev/dri"
    ];
    cuda.onFeatures = [ "cuda" ];
    cuda.paths = opengl.paths ++ [
      "/dev/nvidia*"
    ];
  }
, buildPackages
, formats
, lib
, nix
, python3Packages
, makeWrapper
, runCommand
}:


let
  confPath = (formats.json { }).generate "config.py" {
    inherit allowedPatterns;
    nixExe = lib.getExe nix;
  };
  pname = "nix-required-mounts";
in

runCommand pname
{
  nativeBuildInputs = [
    makeWrapper
    python3Packages.wrapPython
  ];
  meta.mainProgram = pname;
} ''
  ${lib.getExe buildPackages.python3.pkgs.flake8} ${./main.py}

  mkdir -p $out/bin
  install ${./main.py} $out/bin/${pname}
  wrapProgram $out/bin/${pname} --add-flags "--config ${confPath}"
  wrapPythonPrograms
''
