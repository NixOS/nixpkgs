{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "gam";
  version = "6.58";
  format = "other";

  src = fetchFromGitHub {
    owner = "GAM-team";
    repo = "GAM";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-AIaPzYavbBlJyi9arZN8HTmUXM7Tef0SIfE07PmV9Oo=";
  };

  sourceRoot = "${src.name}/src";

  propagatedBuildInputs = with python3.pkgs; [
    chardet
    cryptography
    distro
    filelock
    google-api-python-client
    google-auth
    google-auth-oauthlib
    httplib2
    lxml
    passlib
    pathvalidate
    python-dateutil
    setuptools
  ];

  # Use XDG-ish dirs for configuration. These would otherwise be in the gam
  # package.
  #
  # Using --run as `makeWapper` evaluates variables for --set and --set-default
  # at build time and then single quotes the vars in the wrapper, thus they
  # wouldn't get expanded. But using --run allows setting default vars that are
  # evaluated on run and not during build time.
  makeWrapperArgs = [
    ''--run 'export GAMUSERCONFIGDIR="''${XDG_CONFIG_HOME:-$HOME/.config}/gam"' ''
    ''--run 'export GAMSITECONFIGDIR="''${XDG_CONFIG_HOME:-$HOME/.config}/gam"' ''
    ''--run 'export GAMCACHEDIR="''${XDG_CACHE_HOME:-$HOME/.cache}/gam"' ''
    ''--run 'export GAMDRIVEDIR="$PWD"' ''
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp gam.py $out/bin/gam
    mkdir -p $out/${python3.sitePackages}
    cp -r gam $out/${python3.sitePackages}
    runHook postInstall
  '';

  checkPhase = ''
    runHook preCheck
    ${python3.interpreter} -m unittest discover --pattern "*_test.py" --buffer
    runHook postCheck
  '';

  meta = with lib; {
    description = "Command line management for Google Workspace";
    mainProgram = "gam";
    homepage = "https://github.com/GAM-team/GAM/wiki";
    changelog = "https://github.com/GAM-team/GAM/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ thanegill ];
  };

}
