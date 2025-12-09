{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication {
  pname = "protocol";
  version = "0-unstable-2019-03-28";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "luismartingarcia";
    repo = "protocol";
    rev = "4e8326ea6c2d288be5464c3a7d9398df468c0ada";
    sha256 = "13l10jhf4vghanmhh3pn91b2jdciispxy0qadz4n08blp85qn9cm";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "scripts=['protocol', 'constants.py', 'specs.py']" "scripts=['protocol'], py_modules=['constants', 'specs']"
  '';

  build-system = with python3.pkgs; [ setuptools ];

  meta = with lib; {
    description = "ASCII Header Generator for Network Protocols";
    homepage = "https://github.com/luismartingarcia/protocol";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ teto ];
    mainProgram = "protocol";
  };
}
