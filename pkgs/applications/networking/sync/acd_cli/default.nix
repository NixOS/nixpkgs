{
  lib,
  fetchFromGitHub,
  buildPythonApplication,
  fuse,
  appdirs,
  colorama,
  python-dateutil,
  requests,
  requests-toolbelt,
  fusepy,
  sqlalchemy,
  setuptools,
}:

buildPythonApplication rec {
  pname = "acd_cli";
  version = "0.3.2";
  format = "setuptools";

  doCheck = false;

  src = fetchFromGitHub {
    owner = "yadayada";
    repo = pname;
    rev = version;
    sha256 = "0a0fr632l24a3jmgla3b1vcm50ayfa9hdbp677ch1chwj5dq4zfp";
  };

  propagatedBuildInputs = [
    appdirs
    colorama
    python-dateutil
    fusepy
    requests
    requests-toolbelt
    setuptools
    sqlalchemy
  ];

  makeWrapperArgs = [ "--prefix LIBFUSE_PATH : ${lib.getLib fuse}/lib/libfuse.so" ];

  postFixup = ''
    function lnOverBin() {
      rm -f $out/bin/{$2,.$2-wrapped}
      ln -s $out/bin/$1 $out/bin/$2
    }
    lnOverBin acd_cli.py acd-cli
    lnOverBin acd_cli.py acd_cli
    lnOverBin acd_cli.py acdcli
  '';

  meta = with lib; {
    description = "Command line interface and FUSE filesystem for Amazon Cloud Drive";
    homepage = "https://github.com/yadayada/acd_cli";
    license = licenses.gpl2;
    maintainers = with maintainers; [ edwtjo ];
  };
}
