{
  lib,
  fetchFromGitHub,
  fuse,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "acd-cli";
  version = "0.3.2";
  format = "setuptools";

  doCheck = false;

  src = fetchFromGitHub {
    owner = "yadayada";
    repo = "acd_cli";
    tag = version;
    hash = "sha256-132CW5EcsgDZOeauBpNyXoFS2Q5rKPqqHIoIKobJDig=";
  };

  dependencies = with python3Packages; [
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

  meta = {
    description = "Command line interface and FUSE filesystem for Amazon Cloud Drive";
    homepage = "https://github.com/yadayada/acd_cli";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ edwtjo ];
  };
}
