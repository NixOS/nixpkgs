{
  lib,
  python3,
  fetchPypi,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "chkcrontab";
  version = "1.7";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    sha256 = "0gmxavjkjkvjysgf9cf5fcpk589gb75n1mn20iki82wifi1pk1jn";
  };

  postPatch = ''
    # cannot install the manpage as it is not present in the wheel
    substituteInPlace setup.py \
      --replace-fail "'doc/chkcrontab.1'" ""
  '';

  build-system = [ python3.pkgs.setuptools ];

  meta = {
    description = "Tool to detect crontab errors";
    mainProgram = "chkcrontab";
    license = lib.licenses.asl20;
    maintainers = [ ];
    homepage = "https://github.com/lyda/chkcrontab";
  };
})
