{ lib, python3Packages, fetchFromGitHub }:

python3Packages.buildPythonApplication rec {
  pname = "rofi-mpd";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "JakeStanger";
    repo = "Rofi_MPD";
    rev = "v${version}";
    sha256 = "12zzx0m2nwyzxzzqgzq30a27k015kcw4ylvs7cyalf5gf6sg27kl";
  };

  propagatedBuildInputs = with python3Packages; [ mutagen mpd2 toml appdirs ];

  # upstream doesn't contain a test suite
  doCheck = false;

  meta = with lib; {
    description = "A rofi menu for interacting with MPD written in Python";
    homepage = "https://github.com/JakeStanger/Rofi_MPD";
    license = licenses.mit;
    maintainers = with maintainers; [ jakestanger ];
    platforms = platforms.all;
  };
}
