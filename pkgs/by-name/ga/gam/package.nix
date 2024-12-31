{ lib
, fetchFromGitHub
, python3
, yubikey-manager
, gitUpdater
, cacert
,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "gam";
  version = "7.02.06";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "GAM-team";
    repo = "GAM";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-NzqAj+MNuMfnj5TUF7fXxNASPZUqaHEiqbrXNQ2F5gQ=";
  };

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  sourceRoot = "${src.name}/src";

  propagatedBuildInputs = with python3.pkgs; [
    chardet
    cryptography
    distro
    filelock
    google-api-python-client
    google-auth
    google-auth-httplib2
    google-auth-oauthlib
    httplib2
    lxml
    passlib
    pathvalidate
    python-dateutil
    yubikey-manager
  ];

  # Use XDG-ish dirs for configuration. These would otherwise be in the gam
  # package.
  #
  # Using --run as `makeWapper` evaluates variables for --set and --set-default
  # at build time and then single quotes the vars in the wrapper, thus they
  # wouldn't get expanded. But using --run allows setting default vars that are
  # evaluated on run and not during build time.
  # Detailed on this page: https://github.com/GAM-team/GAM/wiki/gam.cfg
  makeWrapperArgs = [
    ''--set-default GAM_CA_FILE "${cacert}/etc/ssl/certs/ca-bundle.crt"''
    ''--run 'export GAMCFGDIR="''${XDG_CONFIG_HOME:-$HOME/.config}/gam"' ''
    ''--run 'export GAMUSERCONFIGDIR="''${XDG_CONFIG_HOME:-$HOME/.config}/gam"' ''
    ''--run 'export GAMSITECONFIGDIR="''${XDG_CONFIG_HOME:-$HOME/.config}/gam"' ''
    ''--run 'export GAMCACHEDIR="''${XDG_CACHE_HOME:-$HOME/.cache}/gam"' ''
    ''--run 'export GAMDRIVEDIR="$PWD"' ''
  ];

  postPatch = ''
    cp ../README.md readme.md
    substituteInPlace setup.cfg \
      --replace "version = attr: gam.var.GAM_VERSION" "version = ${version}" \
  '';

  pythonImportsCheck = [ "gam" ];

  meta = with lib; {
    description = "Command line management for Google Workspace";
    mainProgram = "gam";
    homepage = "https://github.com/GAM-team/GAM/wiki";
    changelog = "https://github.com/GAM-team/GAM/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ thanegill ];
  };

}
