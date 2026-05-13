{
  lib,
  python3Packages,
  fetchFromGitHub,
  installShellFiles,
  sg3_utils,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "sasutils";
  version = "0.6.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "stanford-rc";
    repo = "sasutils";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-rx4IxS5q1c3z617F4DBWxuxxSPHKFrw2bTW6b6/qkds=";
  };

  nativeBuildInputs = [ installShellFiles ];

  propagatedBuildInputs = [ sg3_utils ];

  postInstall = ''
    installManPage doc/man/man1/*.1
  '';

  meta = {
    homepage = "https://github.com/stanford-rc/sasutils";
    description = "Set of command-line tools to ease the administration of Serial Attached SCSI (SAS) fabrics";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ aij ];
  };
})
