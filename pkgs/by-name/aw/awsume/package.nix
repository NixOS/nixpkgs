{
  lib,
  installShellFiles,
  fetchFromGitHub,
  python3Packages,
  writableTmpDirAsHomeHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "awsume";
  version = "4.5.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "trek10inc";
    repo = "awsume";
    tag = finalAttrs.version;
    hash = "sha256-lm9YANYckyHDoNbB1wytBm55iyBmUuxFPmZupfpReqc=";
  };

  env.AWSUME_SKIP_ALIAS_SETUP = 1;

  nativeBuildInputs = [ installShellFiles ];

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    colorama
    boto3
    psutil
    pluggy
    pyyaml
  ];

  postPatch = ''
    patchShebangs shell_scripts
    substituteInPlace shell_scripts/{awsume,awsume.fish} --replace-fail "awsumepy" "$out/bin/awsumepy"
    substituteInPlace awsume/configure/autocomplete.py --replace-fail "awsume-autocomplete" "$out/bin/awsume-autocomplete"
  '';

  postInstall = ''
    installShellCompletion --cmd awsume \
      --bash <(PYTHONPATH=./awsume/configure python3 -c"import autocomplete; print(autocomplete.SCRIPTS['bash'])") \
      --zsh <(PYTHONPATH=./awsume/configure python3 -c"import autocomplete; print(autocomplete.ZSH_AUTOCOMPLETE_FUNCTION)") \
      --fish <(PYTHONPATH=./awsume/configure python3 -c"import autocomplete; print(autocomplete.SCRIPTS['fish'])") \

    rm -f $out/bin/awsume.bat
  '';

  preCheck = ''
    mkdir -p $NIX_BUILD_TOP/.home/.awsume

    # required for test_safe_print.py
    touch $NIX_BUILD_TOP/.home/.awsume/config.yaml
  '';

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    writableTmpDirAsHomeHook
    xmltodict
  ];

  meta = {
    description = "Utility for easily assuming AWS IAM roles from the command line";
    homepage = "https://github.com/trek10inc/awsume";
    license = lib.licenses.mit;
    mainProgram = "awsume";
    maintainers = with lib.maintainers; [ nilp0inter ];
  };
})
