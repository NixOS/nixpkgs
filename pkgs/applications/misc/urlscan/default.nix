{ stdenv, python3Packages, fetchFromGitHub }:

python3Packages.buildPythonApplication rec {
  pname = "urlscan";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "firecat53";
    repo = pname;
    rev = version;
    sha256 = "0z24k8sk2zfp2pwysyp844vmhr5vbkj74frwy4i0v5pj60i9jl0v";
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
