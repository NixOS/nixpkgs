{ lib, fetchFromGitHub, pythonPackages, installShellFiles }:

with pythonPackages;

let
  # Watson is currently not compatible with Click 8. See the following
  # upstream issues / MRs:
  #
  # https://github.com/TailorDev/Watson/issues/430
  # https://github.com/TailorDev/Watson/pull/432
  #
  # Workaround the issue by providing click 7 explicitly.
  click7 = pythonPackages.callPackage ../../../development/python-modules/click/7.nix {};
  click7-didyoumean = click-didyoumean.override {
    click = click7;
  };
in buildPythonApplication rec {
  pname = "watson";

  # When you update Watson, please check whether the Click 7
  # workaround above can go away.
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "TailorDev";
    repo = "Watson";
    rev = version;
    sha256 = "0radf5afyphmzphfqb4kkixahds2559nr3yaqvni4xrisdaiaymz";
  };

  postInstall = ''
    installShellCompletion --bash --name watson watson.completion
    installShellCompletion --zsh --name _watson watson.zsh-completion
  '';

  checkInputs = [ pytestCheckHook pytest-mock mock pytest-datafiles ];
  propagatedBuildInputs = [ arrow click7 click7-didyoumean requests ];
  nativeBuildInputs = [ installShellFiles ];

  meta = with lib; {
    homepage = "https://tailordev.github.io/Watson/";
    description = "A wonderful CLI to track your time!";
    license = licenses.mit;
    maintainers = with maintainers; [ mguentner nathyong oxzi ];
  };
}
