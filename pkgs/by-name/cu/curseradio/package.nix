{
  lib,
  fetchFromGitHub,
  replaceVars,
  python3Packages,
  mpv,
}:

python3Packages.buildPythonApplication {
  version = "0.2";
  format = "setuptools";
  pname = "curseradio";

  src = fetchFromGitHub {
    owner = "chronitis";
    repo = "curseradio";
    rev = "1bd4bd0faeec675e0647bac9a100b526cba19f8d";
    sha256 = "11bf0jnj8h2fxhpdp498189r4s6b47vy4wripv0z4nx7lxajl88i";
  };

  propagatedBuildInputs = with python3Packages; [
    requests
    lxml
    pyxdg
  ];

  patches = [
    (replaceVars ./mpv.patch {
      inherit mpv;
    })
  ];

  # No tests
  doCheck = false;

  meta = with lib; {
    description = "Command line radio player";
    mainProgram = "curseradio";
    homepage = "https://github.com/chronitis/curseradio";
    license = licenses.mit;
    maintainers = [ maintainers.eyjhb ];
  };
}
