{
  lib,
  stdenv,
  python3,
  fetchpatch,
  fetchPypi,
  openssl,
  # Many Salt modules require various Python modules to be installed,
  # passing them in this array enables Salt to find them.
  extraInputs ? [ ],
}:

python3.pkgs.buildPythonApplication rec {
  pname = "salt";
  version = "3007.9";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-H3cNa5ylVo+SbZjt/NJtznHAT2CUJD25EoV5U+PUpW0=";
  };

  patches = [
    ./fix-libcrypto-loading.patch
    (fetchpatch {
      name = "urllib.patch";
      url = "https://src.fedoraproject.org/rpms/salt/raw/1c6e7b7a88fb81902f5fcee32e04fa80713b81f8/f/urllib.patch";
      hash = "sha256-yldIurafduOAYpf2X0PcTQyyNjz5KKl/N7J2OTEF/c0=";
    })
  ];

  postPatch = ''
    substituteInPlace "salt/utils/rsax931.py" \
      --subst-var-by "libcrypto" "${lib.getLib openssl}/lib/libcrypto${stdenv.hostPlatform.extensions.sharedLibrary}"
    substituteInPlace requirements/base.txt \
      --replace contextvars ""

    # Don't require optional dependencies on Darwin, let's use
    # `extraInputs` like on any other platform
    echo -n > "requirements/darwin.txt"

    # Remove windows-only requirement
    substituteInPlace "requirements/zeromq.txt" \
      --replace 'pyzmq==25.0.2 ; sys_platform == "win32"' ""
  '';

  propagatedBuildInputs =
    with python3.pkgs;
    [
      cryptography
      distro
      jinja2
      jmespath
      looseversion
      markupsafe
      msgpack
      packaging
      psutil
      pycryptodomex
      pyyaml
      pyzmq
      requests
      tornado
    ]
    ++ extraInputs;

  # Don't use fixed dependencies on Darwin
  USE_STATIC_REQUIREMENTS = "0";

  # The tests fail due to socket path length limits at the very least;
  # possibly there are more issues but I didn't leave the test suite running
  # as is it rather long.
  doCheck = false;

  meta = {
    homepage = "https://saltproject.io/";
    changelog = "https://docs.saltproject.io/en/latest/topics/releases/${version}.html";
    description = "Portable, distributed, remote execution and configuration management system";
    maintainers = with lib.maintainers; [ Flakebi ];
    license = lib.licenses.asl20;
  };
}
