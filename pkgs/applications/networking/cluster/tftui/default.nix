{ lib
, buildPythonApplication
, fetchPypi
, makeWrapper
, poetry-core
, posthog
, pyperclip
, requests
, rich
, textual
, enableUsageTracking ? false
}:

buildPythonApplication rec {
  pname = "tftui";
  version = "0.12.4";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-E4Y0qA7SooMlHh+oSFUl1hfblpirr/Jdb1C2fqU43t0=";
  };

  propagatedBuildInputs = [
    posthog
    pyperclip
    requests
    rich
    textual
  ];

  nativeBuildInputs = [
    makeWrapper
    poetry-core
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
    changelog = "https://github.com/idoavrah/terraform-tui/releases";
    license = licenses.asl20;
    maintainers = with maintainers; teams.bitnomial.members;
    mainProgram = "tftui";
  };
}
