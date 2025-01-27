{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication {
  pname = "ci-edit";
  version = "51-unstable-2023-04-11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "google";
    repo = "ci_edit";
    # Last build iteration is v51 from 2021, but there are some recent
    # additions of syntax highlighting and dictionary files.
    rev = "2976f01dc6421b5639505292b335212d413d044f";
    hash = "sha256-DwVNNotRcYbvJX6iXffSQyZMFTxQexIhfG8reFmozN8=";
  };

  nativeBuildInputs = with python3.pkgs; [
    setuptools
  ];

  postInstall = ''
    ln -s $out/bin/ci.py $out/bin/ci_edit
    ln -s $out/bin/ci.py $out/bin/we
    install -Dm644 $src/app/*.words $out/${python3.sitePackages}/app/
  '';

  pythonImportsCheck = [ "app" ];

  meta = with lib; {
    description = "Terminal text editor with mouse support and ctrl+Q to quit";
    homepage = "https://github.com/google/ci_edit";
    license = licenses.asl20;
    maintainers = with maintainers; [ katexochen ];
    mainProgram = "ci_edit";
    platforms = platforms.unix;
  };
}
