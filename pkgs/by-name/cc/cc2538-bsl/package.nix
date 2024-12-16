{
  lib,
  fetchFromGitHub,
  fetchpatch,
  python3Packages,
}:

python3Packages.buildPythonPackage rec {
  pname = "cc2538-bsl";
  version = "2.1-unstable-2023-10-03";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "JelmerT";
    repo = "cc2538-bsl";
    rev = "4d64ac633dbaf29d098842c5937ed6eea2fd7c45";
    hash = "sha256-NX2jPYAz15bSucj/YR5E/0eJy/cbszSrNxyJHRsbXxo=";
  };

  patches = [
    (fetchpatch {
      # fix extras specification in setup.py; https://github.com/JelmerT/cc2538-bsl/pull/143
      url = "https://github.com/JelmerT/cc2538-bsl/commit/c70f58ec0222357db8020176711d6d45cf24da35.patch";
      hash = "sha256-Rxm/TRcm87WgRfq60cu0loyrbJmZou09XYR7uhrhhj8=";
    })
  ];

  env.SETUPTOOLS_SCM_PRETEND_VERSION = "0.1.dev0+g${lib.substring 0 7 src.rev}";

  nativeBuildInputs = with python3Packages; [
    setuptools-scm
  ];

  propagatedBuildInputs = with python3Packages; [
    intelhex
    pyserial
    python-magic
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    scripttest
  ];

  postInstall = ''
    # Remove .py from binary
    mv $out/bin/cc2538-bsl.py $out/bin/cc2538-bsl
  '';

  meta = with lib; {
    homepage = "https://github.com/JelmerT/cc2538-bsl";
    description = "Flash TI SimpleLink chips (CC2538, CC13xx, CC26xx) over serial";
    license = licenses.bsd3;
    maintainers = with maintainers; [ lorenz ];
    mainProgram = "cc2538-bsl";
  };
}
