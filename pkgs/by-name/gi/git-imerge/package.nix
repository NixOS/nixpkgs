{
  lib,
  python3Packages,
  fetchPypi,
  installShellFiles,
}:

python3Packages.buildPythonApplication rec {
  pname = "git-imerge";
  version = "1.2.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "df5818f40164b916eb089a004a47e5b8febae2b4471a827e3aaa4ebec3831a3f";
  };

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --bash completions/git-imerge
  '';

  meta = {
    homepage = "https://github.com/mhagger/git-imerge";
    description = "Perform a merge between two branches incrementally";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "git-imerge";
  };
}
