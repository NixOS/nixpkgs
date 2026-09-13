{
  lib,
  fetchFromGitHub,
  python3,
  versionCheckHook,
}:

let
  inherit (python3.pkgs)
    buildPythonApplication
    jinja2
    packaging
    progressbar33
    xlsxwriter
    ;
in
buildPythonApplication (finalAttrs: {
  pname = "porting-advisor-for-graviton";
  version = "1.1.1";
  format = "other"; # Only has a requirements.txt

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "aws";
    repo = "porting-advisor-for-graviton";
    tag = "v${finalAttrs.version}";
    hash = "sha256-73XZXy9hCRFGHGAxjThLE5mAptQZpr1G/t1v2Fx3Bpg=";
  };

  dependencies = [
    jinja2
    packaging
    progressbar33
    xlsxwriter
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp src/porting-advisor.py $out/bin/porting-advisor-graviton
    chmod +x $out/bin/porting-advisor-graviton

    # Install the advisor Python package
    mkdir -p $out/${python3.sitePackages}
    cp -r src/advisor $out/${python3.sitePackages}/

    runHook postInstall
  '';

  # This automatically wraps Python programs with the right environment
  postFixup = ''
    wrapPythonPrograms
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "AWS Porting Advisor for Graviton helps customers assess and prepare their applications for migration to AWS Graviton processors";
    homepage = "https://github.com/aws/porting-advisor-for-graviton";
    changelog = "https://github.com/aws/porting-advisor-for-graviton/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jherland ];
    mainProgram = "porting-advisor-graviton";
    platforms = lib.platforms.linux;
  };
})
