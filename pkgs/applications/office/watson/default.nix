{ lib, fetchFromGitHub, python3, installShellFiles }:

let
  # Watson is currently not compatible with Click 8. See the following
  # upstream issues / MRs:
  #
  # https://github.com/TailorDev/Watson/issues/430
  # https://github.com/TailorDev/Watson/pull/432
  #
  # Workaround the issue by providing click 7 explicitly.
  python = python3.override {
    packageOverrides = self: super: {
      # Use click 7
      click = self.callPackage ../../../development/python2-modules/click/default.nix { };
    };
  };
in with python.pkgs; buildPythonApplication rec {
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
    installShellCompletion --fish watson.fish
  '';

  checkInputs = [ pytestCheckHook pytest-mock mock pytest-datafiles ];
  propagatedBuildInputs = [ arrow click click-didyoumean requests ];
  nativeBuildInputs = [ installShellFiles ];

  meta = with lib; {
    homepage = "https://tailordev.github.io/Watson/";
    description = "A wonderful CLI to track your time!";
    license = licenses.mit;
    maintainers = with maintainers; [ mguentner nathyong oxzi ];
  };
}
