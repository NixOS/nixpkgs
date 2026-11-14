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
    hash = "sha256-lSWLC7p0IWDJbwoD36+OkTUpVkj2DgirVfBt4qAEgY4=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "scripts=['protocol', 'constants.py', 'specs.py']" "scripts=['protocol'], py_modules=['constants', 'specs']"
  '';

  build-system = with python3.pkgs; [ setuptools ];

  meta = {
    description = "ASCII Header Generator for Network Protocols";
    homepage = "https://github.com/luismartingarcia/protocol";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ teto ];
    mainProgram = "protocol";
  };
}
