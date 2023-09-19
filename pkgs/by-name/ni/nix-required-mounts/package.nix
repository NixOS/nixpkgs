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
, python3
, runCommand
}:


let
  confPath = (formats.pythonVars { }).generate "config.py" {
    CONFIG = {
      inherit allowedPatterns;
      nixExe = lib.getExe nix;
    };
  };
  pname = "nix-required-mounts";
in

runCommand pname
{
  inherit confPath;
  meta.mainProgram = pname;
} ''
  ${lib.getExe buildPackages.python3.pkgs.flake8} ${./main.py}

  cat > main.py << EOF
  #!${lib.getExe python3}

  $(cat ${./main.py})
  EOF

  sed -ie '
    /^entrypoint()$/ {
      x ;
      r ${confPath}
      }' main.py

  echo "entrypoint()" >> main.py

  mkdir -p $out/bin
  install main.py $out/bin/${pname}
''
