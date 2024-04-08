{ lib
, fetchFromGitHub
, makeWrapper
, python3
, enableUsageTracking ? false
}:

python3.pkgs.buildPythonApplication rec {
  pname = "tftui";
  version = "0.12.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "idoavrah";
    repo = "terraform-tui";
    rev = "refs/tags/v${version}";
    hash = "sha256-vK1qKf8+RxwHUpuEQ97PcwGvObNVpd88kAb3DFRoRG0=";
  };

  pythonRelaxDeps = [
    "textual"
  ];

  nativeBuildInputs = with python3.pkgs; [
    makeWrapper
    poetry-core
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = with python3.pkgs; [
    posthog
    pyperclip
    requests
    rich
    textual
  ];

  pythonImportsCheck = [
    "tftui"
  ];

  postInstall = lib.optionalString (!enableUsageTracking) ''
    wrapProgram $out/bin/tftui \
      --add-flags "--disable-usage-tracking"
  '';

  meta = with lib; {
    description = "Textual UI to view and interact with Terraform state";
    homepage = "https://github.com/idoavrah/terraform-tui";
    changelog = "https://github.com/idoavrah/terraform-tui/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; teams.bitnomial.members;
    mainProgram = "tftui";
  };
}
