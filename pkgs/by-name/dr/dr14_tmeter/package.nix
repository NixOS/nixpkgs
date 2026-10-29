{
  lib,
  fetchFromGitHub,
  python3Packages,
  pkgs,
}:

python3Packages.buildPythonApplication {
  pname = "dr14_tmeter";
  version = "1.0.16-unstable-2025-09-27";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "hboetes";
    repo = "dr14_t.meter";
    rev = "f9d62f60c30d9404d4c4b644931e76049332310c";
    sha256 = "sha256-3z9Gi32aG6Tk9UHpfT1VqmBZpFJrlKB+NZFu3CH+18U=";
  };

  propagatedBuildInputs = with pkgs; [
    python3Packages.numpy
    python3Packages.mutagen
    flac
    vorbis-tools
    ffmpeg
    faad2
    lame
  ];

  # There are no tests
  doCheck = false;

  meta = {
    description = "Compute the DR14 of a given audio file according to the procedure described by the Pleasurize Music Foundation";
    mainProgram = "dr14_tmeter";
    homepage = "https://github.com/hboetes/dr14_t.meter";
    maintainers = with lib.maintainers; [ sciencentistguy ];
    license = lib.licenses.gpl3Plus;
  };
}
