{ lib
, python3Packages
, fetchFromGitHub
}:
python3Packages.buildPythonApplication {
  pname = "fileinfo";
  version = "unstable-2022-09-16";
  src = fetchFromGitHub {
    owner = "sdushantha";
    repo = "fileinfo";
    rev = "503f26189ad5043bad3fe71333dd5ba3ffbce485";
    hash = "sha256-tEmCsR3LmTxeDZAbMvbIwqp/6uaGNUhgGlm18gdsnOw=";
  };

  propagatedBuildInputs = with python3Packages; [ requests ];

  meta = with lib; {
    homepage = "https://github.com/sdushantha/fileinfo";
    description = "A file extension metadata lookup tool";
    license = licenses.mit;
    maintainers = with maintainers; [ h7x4 ];
    mainProgram = "fileinfo";
  };
}
