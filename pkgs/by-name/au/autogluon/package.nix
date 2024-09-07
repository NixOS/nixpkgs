{
  lib,
  fetchFromGitHub,
  python3Packages,
  makeWrapper,
}:

# Build a Python application using the buildPythonApplication function from python3Packages
python3Packages.buildPythonApplication rec {
  pname = "autogluon";
  version = "1.1.1";

  # Fetch the source code from GitHub
  src = fetchFromGitHub {
    owner = "autogluon";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-vM1XSACXzhIEZPXB+QnvN1nBDqQwzNCsZXhSwsHWXuU=";
  };

  # Specify build-time dependencies
  nativeBuildInputs = with python3Packages; [
    makeWrapper # Used for wrapping executables
    setuptools # Required for Python packaging
  ];

  # Specify runtime dependencies
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

  # Install subpackages after the main package installation
  postInstall = ''
    for subpackage in core common features tabular multimodal timeseries eda; do
      if [ -d "$subpackage" ]; then
        pushd $subpackage
        ${python3Packages.python.interpreter} setup.py install --prefix=$out --single-version-externally-managed --root=/
        popd
      fi
    done
  '';

  # Wrap the installed binaries to ensure they can find the required Python modules
  postFixup = ''
    for f in $out/bin/*; do
      wrapProgram $f --prefix PYTHONPATH : $PYTHONPATH
    done
  '';

  # Specify which Python imports to check to verify the installation
  pythonImportsCheck = [ "autogluon" ];

  meta = with lib.maintainers; {
    description = "AutoML toolkit for deep learning";
    homepage = "https://github.com/autogluon/autogluon";
    license = lib.licenses.asl20;
    maintainers = [ maintainers.rrrodzilla ];
  };
}
