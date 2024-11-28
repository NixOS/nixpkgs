{ lib, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "grabserial";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "tbird20d";
    repo = "grabserial";
    rev = "v${version}";
    sha256 = "0ryk4w8q6zfmia71nwnk5b7xaxw0sf45dw9q50xp7k76i3k5f9f3";
  };

  propagatedBuildInputs = [ python3Packages.pyserial ];

  # no usable tests
  doCheck = false;

  meta = with lib; {
    description = "Python based serial dump and timing program";
    mainProgram = "grabserial";
    homepage = "https://github.com/tbird20d/grabserial";
    license = licenses.gpl2;
    maintainers = with maintainers; [ vmandela ];
    platforms = platforms.linux;
  };
}
