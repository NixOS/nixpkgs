{ lib
, python3
, fetchFromGitHub
, installShellFiles
, awscli
}:

python3.pkgs.buildPythonApplication rec {
  pname = "nimbo";
  version = "0.3.0";
  disabled = python3.pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "nimbo-sh";
    repo = pname;
    rev = "v${version}";
    sha256 = "YC5T02Sw22Uczufbyts8l99oCQW4lPq0gPMRXCoKsvw=";
  };

  # Rich + Colorama are added in `propagatedBuildInputs`
  postPatch = ''
    substituteInPlace setup.py \
      --replace "awscli>=1.19<2.0" "" \
      --replace "colorama==0.4.3" "" \
      --replace "rich>=10.1.0" ""
  '';

  nativeBuildInputs = [ installShellFiles ];

  propagatedBuildInputs = with python3.pkgs; [
    setuptools
    boto3
    requests
    click
    pyyaml
    pydantic
    rich
    colorama
  ];

  # nimbo tests require an AWS instance
  doCheck = false;
  pythonImportsCheck = [ "nimbo" ];

  makeWrapperArgs = [
    "--prefix" "PATH" ":" (lib.makeBinPath [ awscli ])
  ];

  postInstall = ''
    installShellCompletion --cmd nimbo \
      --zsh <(_NIMBO_COMPLETE=source_zsh $out/bin/nimbo) \
      --bash <(_NIMBO_COMPLETE=source_bash $out/bin/nimbo) \
      --fish  <(_NIMBO_COMPLETE=source_fish $out/bin/nimbo)
  '';

  meta = with lib; {
    description = "Run machine learning jobs on AWS with a single command";
    homepage = "https://github.com/nimbo-sh/nimbo";
    license = licenses.bsl11;
    maintainers = with maintainers; [ noreferences ];
  };
}
