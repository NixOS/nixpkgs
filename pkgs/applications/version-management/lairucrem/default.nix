{ lib, buildPythonApplication, fetchFromSourcehut
, pytest, mock, sh, mercurial
, urwid, setuptools }:

buildPythonApplication rec {
  pname = "lairucrem";
  version = "5.4.0";

  src = fetchFromSourcehut {
    vc = "hg";
    owner = "~alainl";
    repo = pname;
    rev = version;
    sha256 = "sha256-QW7rKpnXBWmlEEzMJnW19vdhTn5UmC4hDZvIL64kLIQ=";
  };

  propagatedBuildInputs = [ urwid setuptools ];
  checkInputs = [ pytest mock sh mercurial ];
  checkPhase = "py.test --doctest-modules -q";

  meta = with lib; {
    description = "A simple and powerful text-based interactive user interface for Mercurial";
    homepage = "https://hg.sr.ht/~alainl/lairucrem";
    license = licenses.wtfpl;
    maintainers = with maintainers; [ pacien ];
  };
}
