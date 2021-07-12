{ lib, fetchFromGitHub, python3, dbus, gnupg }:

python3.pkgs.buildPythonApplication rec {
  pname = "pass-secret-service";
  # PyPI has old alpha version. Since then the project has switched from using a
  # seemingly abandoned D-Bus package pydbus and started using maintained
  # dbus-next. So let's use latest from GitHub.
  version = "unstable-2020-04-12";

  src = fetchFromGitHub {
    owner = "mdellweg";
    repo = "pass_secret_service";
    rev = "f6fbca6ac3ccd16bfec407d845ed9257adf74dfa";
    sha256 = "0rm4pbx1fiwds1v7f99khhh7x3inv9yniclwd95mrbgljk3cc6a4";
  };


  # Need to specify session.conf file for tests because it won't be found under
  # /etc/ in check phase.
  postPatch = ''
    substituteInPlace Makefile \
      --replace \
        "dbus-run-session" \
        "dbus-run-session --config-file=${dbus}/share/dbus-1/session.conf"
  '';

  propagatedBuildInputs = with python3.pkgs; [
    click
    cryptography
    dbus-next
    decorator
    pypass
    secretstorage
  ];

  checkInputs =
    let
      ps = python3.pkgs;
    in
    [
      dbus
      gnupg
      ps.pytest
      ps.pytest-asyncio
      ps.pypass
    ];

  checkPhase = ''
    runHook preCheck
    make test
    runHook postCheck
  '';

  meta = {
    description = "Libsecret D-Bus API with pass as the backend";
    homepage = "https://github.com/mdellweg/pass_secret_service/";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ jluttine ];
  };
}
