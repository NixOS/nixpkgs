{
  lib,
  python3Packages,
  fetchgit,
  git,
  makeWrapper,
}:

python3Packages.buildPythonApplication rec {
  pname = "korgalore";
  version = "0.6.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/utils/korgalore/korgalore.git";
    tag = "v${version}";
    hash = "sha256-fd1y7nBqdtr6cJBV6NirlcaVkxxE7r1TC98F/6rodsE=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    google-auth
    google-auth-oauthlib
    google-auth-httplib2
    google-api-python-client
    click
    click-log
  ];

  nativeBuildInputs = [ makeWrapper ];

  # We're not dependencing on PyGObject here since it is only required for the
  # GTK GUI. This current package, does not build the GUI, only the command line
  # application.

  # korgalore shells out to `git` to read public-inbox repositories, so put it
  # on the runtime PATH.
  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [ git ])
  ];

  nativeCheckInputs = with python3Packages; [ pytestCheckHook ] ++ [ git ];

  # A couple of tests write into $HOME; the sandbox default (/homeless-shelter)
  # is not writable.
  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  pythonImportsCheck = [ "korgalore" ];

  meta = {
    description = "Tool to feed public-inbox messages into your Gmail inbox";
    homepage = "https://korgalore.docs.kernel.org/";
    changelog = "https://git.kernel.org/pub/scm/utils/korgalore/korgalore.git/tree/CHANGELOG";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ darnir ];
    mainProgram = "kgl";
  };
}
