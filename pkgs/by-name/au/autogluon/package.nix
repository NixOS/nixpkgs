{
  lib,
  fetchFromGitHub,
  python3Packages,
  makeWrapper,
}:

python3Packages.buildPythonApplication rec {
  pname = "autogluon";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "autogluon";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-vM1XSACXzhIEZPXB+QnvN1nBDqQwzNCsZXhSwsHWXuU=";
  };

  nativeBuildInputs = with python3Packages; [
    makeWrapper
    setuptools
  ];

  propagatedBuildInputs = with python3Packages; [
    numpy
    pandas
    scipy
    scikit-learn
    tqdm
    pytz
    requests
    boto3
    pyyaml
    psutil
    matplotlib
    pillow
    networkx
  ];

  # Developer note: Tests are disabled because they're not used in the main full_install.sh file
  # used by autogluon during normal installs which this package aims to replicate.
  doCheck = false;

  # Create a custom setup.py file before building
  # Autogluon uses a script file to run the setup.py files in each subdir
  # so this creates a setup.py file in the root to do the same thing
  preBuild = ''
        cat > setup.py << EOF
    from setuptools import setup, find_namespace_packages
    setup(
        name="${pname}",
        version="${version}",
        packages=find_namespace_packages(include=['autogluon*']),
        package_data={"": ["*.txt", "*.md", "*.rst", "*.yml", "*.yaml"]},
        include_package_data=True,
        install_requires=[
            'numpy',
            'pandas',
            'scipy',
            'scikit-learn',
            'tqdm',
            'pytz',
            'requests',
            'boto3',
            'pyyaml',
            'psutil<6,>=5.7.3',
            'matplotlib',
            'pillow',
            'networkx',
        ],
    )
    EOF
  '';

  postInstall = ''
    for subpackage in core common features tabular multimodal timeseries eda; do
      if [ -d "$subpackage" ]; then
        pushd $subpackage
        ${python3Packages.python.interpreter} setup.py install --prefix=$out --single-version-externally-managed --root=/
        popd
      fi
    done
  '';

  # No postFixup needed as this is a Python library package with no executables in $out/bin

  pythonImportsCheck = [ "autogluon" ];

  meta = {
    description = "AutoML toolkit for deep learning";
    homepage = "https://github.com/autogluon/autogluon";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ rrrodzilla ];
  };
}
