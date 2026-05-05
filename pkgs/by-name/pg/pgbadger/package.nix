{
  bzip2,
  fetchFromGitHub,
  perlPackages,
  lib,
  nix-update-script,
  versionCheckHook,
  which,
}:
perlPackages.buildPerlPackage rec {
  pname = "pgbadger";
  version = "13.2";

  src = fetchFromGitHub {
    owner = "darold";
    repo = "pgbadger";
    tag = "v${version}";
    hash = "sha256-i2EamGk+urwTQNaiphJw0QIjLq/OpRdQzsR6ytaZc7k=";
  };

  postPatch = ''
    patchShebangs ./pgbadger
  '';

  outputs = [ "out" ];

  env.PERL_MM_OPT = "INSTALL_BASE=${placeholder "out"}";

  buildInputs = [
    perlPackages.JSONXS
    perlPackages.PodMarkdown
    perlPackages.TextCSV_XS
  ];

  nativeCheckInputs = [
    bzip2
    which
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://pgbadger.darold.net/";
    description = "Fast PostgreSQL log analyzer";
    changelog = "https://github.com/darold/pgbadger/releases/tag/v${version}";
    license = lib.licenses.postgresql;
    mainProgram = "pgbadger";
    maintainers = with lib.maintainers; [ EpicEric ];
  };
}
