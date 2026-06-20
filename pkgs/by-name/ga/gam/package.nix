{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  yubikey-manager,
  nix-update-script,
  cacert,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "gam";
  version = "7.43.04";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "GAM-team";
    repo = "GAM";
    tag = "v${finalAttrs.version}";
    hash = "sha256-toAYDYkgBuhHaUbMnhSWPRDkhB5C/a0xQVMPTZj9xXM=";
  };

  build-system = [ python3.pkgs.hatchling ];

  dependencies =
    with python3.pkgs;
    [
      arrow
      chardet
      cryptography
      filelock
      google-api-python-client
      google-auth
      google-auth-httplib2
      google-auth-oauthlib
      httplib2
      lxml
      passlib
      pathvalidate
      pysocks
      yubikey-manager
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      distro
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

  pythonImportsCheck = [ "gam" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command line management for Google Workspace";
    mainProgram = "gam";
    homepage = "https://github.com/GAM-team/GAM/wiki";
    changelog = "https://github.com/GAM-team/GAM/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ thanegill ];
  };

})
