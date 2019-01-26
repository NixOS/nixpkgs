{ stdenv, python3Packages, fetchFromGitHub }:

python3Packages.buildPythonApplication rec {
  pname = "urlscan";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "firecat53";
    repo = pname;
    rev = version;
    sha256 = "0np7w38wzs72kxap9fsdliafqs0xfqnfj01i7b0fh7k235bgrapz";
  };

  propagatedBuildInputs = [ python3Packages.urwid ];

  doCheck = false; # No tests available

  meta = with stdenv.lib; {
    description = "Mutt and terminal url selector (similar to urlview)";
    homepage = https://github.com/firecat53/urlscan;
    license = licenses.gpl2;
    maintainers = with maintainers; [ dpaetzel jfrankenau ];
  };
}
