{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "protocol";
  version = "unstable-2019-03-28";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "luismartingarcia";
    repo = "protocol";
    rev = "4e8326ea6c2d288be5464c3a7d9398df468c0ada";
    sha256 = "13l10jhf4vghanmhh3pn91b2jdciispxy0qadz4n08blp85qn9cm";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "scripts=['protocol', 'constants.py', 'specs.py']" "scripts=['protocol'], py_modules=['constants', 'specs']"
  '';

  meta = with lib; {
    description = "ASCII Header Generator for Network Protocols";
    homepage = "https://github.com/luismartingarcia/protocol";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ teto ];
    mainProgram = "protocol";
  };
}
