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
, nixosTests
, python3Packages
, makeWrapper
, runCommand
}:


let
  confPath = (formats.json { }).generate "config.py" {
    inherit allowedPatterns;
    nixExe = lib.getExe nix;
  };
  attrs = builtins.fromTOML (builtins.readFile ./pyproject.toml);
  pname = attrs.project.name;
  inherit (attrs.project) version;
in

python3Packages.buildPythonApplication
{
  inherit pname version;
  pyproject = true;

  src = lib.cleanSource ./.;

  nativeBuildInputs = [
    makeWrapper
    python3Packages.setuptools
  ];

  postFixup = ''
    wrapProgram $out/bin/${pname} --add-flags "--config ${confPath}"
  '';

  passthru = {
    inherit allowedPatterns;
    tests = {
      inherit (nixosTests) nix-required-mounts;
    };
  };
  meta = {
    inherit (attrs.project) description;
    homepage = attrs.project.urls.Homepage;
    license = lib.licenses.mit;
    mainProgram = attrs.project.name;
    maintainers = with lib.maintainers; [ SomeoneSerge ];
  };
}
