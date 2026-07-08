{
  lib,
  python3Packages,
  fetchgit,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "fedpkg";
  version = "1.47";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchgit {
    url = "https://forge.fedoraproject.org/packaging/fedpkg";
    tag = finalAttrs.version;
    hash = "sha256-8vWiBm7Bp3pOv1tqhM9TKi0VubSaUMpUe5LUT1FZVRk=";
  };

  # fedpkg defaults to reading its config from /etc/rpkg, point it at the
  # copy installed into the store so the CLI works without extra setup.
  postPatch = ''
    substituteInPlace fedpkg/__main__.py \
      --replace-fail "'/etc/rpkg/%s.conf'" "'$out/etc/rpkg/%s.conf'"
  '';

  build-system = [
    python3Packages.hatchling
  ];

  dependencies = with python3Packages; [
    argcomplete
    bodhi-client
    distro
    gitpython
    openidc-client
    packaging
    python-bugzilla
    requests
    rpkg
  ];

  pythonImportsCheck = [
    "fedpkg"
  ];

  meta = {
    description = "Fedora plugin to rpkg to manage package sources in a git repository";
    homepage = "https://forge.fedoraproject.org/packaging/fedpkg";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ katexochen ];
    mainProgram = "fedpkg";
  };
})
