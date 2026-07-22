{
  lib,
  stdenv,
  python3,
  fetchPypi,
  openssl,
  # Many Salt modules require various Python modules to be installed,
  # passing them in this array enables Salt to find them.
  extraInputs ? [ ],
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "salt";
  version = "3008.1";
  format = "setuptools";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-abf3Phwx7IjP7CqbvVZsf84Ajdqrmiab4xfPeyb2j/w=";
  };

  patches = [
    ./fix-libcrypto-loading.patch
  ];

  postPatch = ''
    substituteInPlace "salt/utils/rsax931.py" \
      --subst-var-by "libcrypto" "${lib.getLib openssl}/lib/libcrypto${stdenv.hostPlatform.extensions.sharedLibrary}"

    # Don't require optional dependencies on Darwin, let's use
    # `extraInputs` like on any other platform
    echo -n > "requirements/darwin.txt"

    # Fix duplicated script in bin and scripts:
    # FileExistsError: File already exists: /nix/store/...-salt-3008.0/bin/salt
    # See https://github.com/pypa/installer/pull/170 and https://github.com/saltstack/salt/issues/65083
    substituteInPlace "tools/pkg/salt_build_backend.py" \
      --replace-fail 'get_scripts(dist=None):' $'get_scripts(dist=None):\n    return []'
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
  env.USE_STATIC_REQUIREMENTS = "0";

  # The tests fail due to socket path length limits at the very least;
  # possibly there are more issues but I didn't leave the test suite running
  # as is it rather long.
  doCheck = false;

  meta = {
    homepage = "https://saltproject.io/";
    changelog = "https://docs.saltproject.io/en/latest/topics/releases/${finalAttrs.version}.html";
    description = "Portable, distributed, remote execution and configuration management system";
    maintainers = with lib.maintainers; [ Flakebi ];
    license = lib.licenses.asl20;
  };
})
