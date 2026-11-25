{
  lib,
  fetchFromGitHub,
  pythonPackages,
  mopidy,
  pkgs,
  extraPkgs ? pkgs: [ ],
}:

pythonPackages.buildPythonApplication (finalAttrs: {
  pname = "mopidy-youtube";
  version = "4.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "natumbri";
    repo = "mopidy-youtube";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/0kehIM60pAQld4dYHAE+bdSdGRzHO5tmeeqYzDXnC0=";
  };

  build-system = [
    pythonPackages.setuptools
  ];

  dependencies = [
    mopidy
    pythonPackages.cachetools
    pythonPackages.pykka
    pythonPackages.requests
    pythonPackages.tornado
    pythonPackages.ytmusicapi
    pythonPackages.yt-dlp
  ]
  ++ extraPkgs pkgs; # should we remove this? If we do, don't forget to also change the docs!

  nativeCheckInputs = [ pythonPackages.pytestCheckHook ];

  pythonImportsCheck = [ "mopidy_youtube" ];

  meta = {
    description = "Mopidy extension for playing music from YouTube";
    homepage = "https://github.com/natumbri/mopidy-youtube";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
