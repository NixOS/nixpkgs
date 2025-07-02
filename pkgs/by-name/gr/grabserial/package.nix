{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "grabserial";
  version = "2.1.8";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "tbird20d";
    repo = "grabserial";
    tag = "v${version}";
    hash = "sha256-XHI5r4OkJUtMuH83jKvNttEpKpqARjxj9SDLzhSPxSc=";
  };

  dependencies = [ python3Packages.pyserial ];

  # no usable tests
  doCheck = false;

  meta = {
    description = "Python based serial dump and timing program";
    mainProgram = "grabserial";
    homepage = "https://github.com/tbird20d/grabserial";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ vmandela ];
    platforms = lib.platforms.linux;
  };
}
