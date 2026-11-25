{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

let
  self = python3Packages.buildPythonApplication {
    pname = "setconf";
    version = "0.7.8";

    src = fetchFromGitHub {
      owner = "xyproto";
      repo = "setconf";
      rev = self.version;
      hash = "sha256-ZyqtMGHd3AbpirWkHhMiPKLVr3H6Fw2IVPuImWbuW3U=";
    };

    build-system = with python3Packages; [ setuptools ];

    pyproject = true;

    meta = {
      homepage = "https://github.com/xyproto/setconf";
      description = "Small utility for changing settings in configuration textfiles";
      changelog = "https://github.com/xyproto/setconf/releases/tag/${self.src.rev}";
      mainProgram = "setconf";
      maintainers = [ ];
      license = lib.licenses.gpl2Only;
    };
  };
in
self
