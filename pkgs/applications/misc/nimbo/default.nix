{ lib
, python3
, fetchFromGitHub
, installShellFiles
, awscli
}:

python3.pkgs.buildPythonApplication rec {
  pname = "nimbo";
<<<<<<< HEAD
  version = "0.3.0";
=======
  version = "0.2.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  disabled = python3.pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "nimbo-sh";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "YC5T02Sw22Uczufbyts8l99oCQW4lPq0gPMRXCoKsvw=";
  };

  # Rich + Colorama are added in `propagatedBuildInputs`
  postPatch = ''
    substituteInPlace setup.py \
      --replace "awscli>=1.19<2.0" "" \
      --replace "colorama==0.4.3" "" \
      --replace "rich>=10.1.0" ""
=======
    sha256 = "1fs28s9ynfxrb4rzba6cmik0kl0q0vkpb4zdappsq62jqf960k24";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "awscli>=1.19<2.0" ""
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  nativeBuildInputs = [ installShellFiles ];

  propagatedBuildInputs = with python3.pkgs; [
    setuptools
    boto3
    requests
    click
    pyyaml
    pydantic
<<<<<<< HEAD
    rich
    colorama
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    maintainers = with maintainers; [ noreferences ];
=======
    maintainers = with maintainers; [ alexeyre noreferences ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
