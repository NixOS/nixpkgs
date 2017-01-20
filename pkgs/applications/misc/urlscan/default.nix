{ stdenv, buildPythonPackage, fetchFromGitHub, urwid, pythonOlder }:

buildPythonPackage rec {
  name = "urlscan-${version}";
  version = "0.8.3";

  src = fetchFromGitHub {
    owner = "firecat53";
    repo = "urlscan";
    rev = version;
    # (equivalent but less nice(?): rev = "00333f6d03bf3151c9884ec778715fc605f58cc5")
    sha256 = "0l40anfznam4d3q0q0jp2wwfrvfypz9ppbpjyzjdrhb3r2nizb0y";
  };

  propagatedBuildInputs = [ urwid ];

  # FIXME doesn't work with 2.7; others than 2.7 and 3.5 were not tested (yet)
  disabled = !pythonOlder "3.5";

  meta = with stdenv.lib; {
    description = "Mutt and terminal url selector (similar to urlview)";
    license = licenses.gpl2;
    maintainers = [ maintainers.dpaetzel ];
  };
}
