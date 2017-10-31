{ stdenv, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  name = "peru-${version}";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "buildinspace";
    repo = "peru";
    rev = "${version}";
    sha256 = "0hvp6pvpsz0f98az4f1wl93gqlz6wj24pjnc5zs1har9rqlpq8y8";
  };

  propagatedBuildInputs = with python3Packages; [ pyyaml docopt ];

  # No tests in archive
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/buildinspace/peru;
    description = "A tool for including other people's code in your projects";
    license = licenses.mit;
    platforms = platforms.unix;
  };

}
