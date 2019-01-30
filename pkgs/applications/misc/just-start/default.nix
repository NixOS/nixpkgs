{ stdenv, lib, buildPythonApplication, fetchFromGitHub, isPy3k, pexpect, urwid, toml, pydantic, poetry
, pytest, pytest-mock, coverage
 }:

buildPythonApplication rec {
  pname = "just-start";
  version = "2019-03-30";

  src = fetchFromGitHub {
    owner = "AliGhahraei";
    repo = pname;
    rev = "3c4a6102f304d1e58b8f0e116b607a1355c6544a";
    sha256 = "0wg0nc7xglj1dw6c95nw08hvnxgqzdr4rc8cgv94yyx3ibfnscz6";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'pydantic = "^0.21.0"' \
                'pydantic = ">=0.21.0"'
  '';

  format = "pyproject";

  buildInputs = [ poetry ];
  propagatedBuildInputs = [ pexpect urwid toml pydantic ];

  LC_ALL = "C.UTF-8";

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  checkInputs = [ pytest pytest-mock coverage ];
  doCheck = false; # check phase?

  disabled = !isPy3k;

  meta = with lib; {
    description = "An app to defeat procrastination (terminal pomodoro w/taskwarrior)";
    license = licenses.gpl3;
    homepage = https://github.com/AliGhahraei/just-start;
    maintainers = with maintainers; [ dtzWill ];
  };
}
