{
  lib,
  stdenv,
  python3,
  fetchFromGitHub,
  nix-update-script,
  cacert,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "npm-lockfile-fix";
  version = "0.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jeslie0";
    repo = "npm-lockfile-fix";
    rev = "v${finalAttrs.version}";
    hash = "sha256-P93OowrVkkOfX5XKsRsg0c4dZLVn2ZOonJazPmHdD7g=";
  };

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies = with python3.pkgs; [
    requests
  ];

  doCheck = false; # no tests

  # requests resolves the CA bundle via REQUESTS_CA_BUNDLE before falling back
  # to NIX_SSL_CERT_FILE, which on Darwin points to a host path that is not
  # available inside a sandboxed build. Set it explicitly so the package works
  # whenever it is invoked from a sandboxed environment.
  makeWrapperArgs = lib.optionals stdenv.hostPlatform.isDarwin [
    "--set"
    "REQUESTS_CA_BUNDLE"
    "${cacert}/etc/ssl/certs/ca-bundle.crt"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Add missing integrity and resolved fields to a package-lock.json file";
    homepage = "https://github.com/jeslie0/npm-lockfile-fix";
    mainProgram = "npm-lockfile-fix";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      felschr
    ];
  };
})
