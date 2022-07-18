{ lib
, fetchFromGitHub
, python3
, dbus
, gnupg
, coreutils
, nixosTests
}:

python3.pkgs.buildPythonApplication rec {
  pname = "pass-secret-service";
  # PyPI has old alpha version. Since then the project has switched from using a
  # seemingly abandoned D-Bus package pydbus and started using maintained
  # dbus-next. So let's use latest from GitHub.
  version = "unstable-2022-03-21";

  src = fetchFromGitHub {
    owner = "mdellweg";
    repo = "pass_secret_service";
    rev = "149f8557e07098eee2f46561eea61e83255ac59b";
    sha256 = "sha256-+/pFi6+K8rl0Ihm6cp/emUQVtau6+Apl8/VEr9AI0Xs=";
  };

  patches = [
    # Only needed until https://github.com/mdellweg/pass_secret_service/pull/30
    # is merged.
    ./int_from_bytes-deprecation-fix.patch
  ];

  # Need to specify session.conf file for tests because it won't be found under
  # /etc/ in check phase.
  postPatch = ''
    substituteInPlace Makefile \
      --replace "dbus-run-session" "dbus-run-session --config-file=${dbus}/share/dbus-1/session.conf" \
      --replace '-p $(relpassstore)' '-p $(PASSWORD_STORE_DIR)' \
      --replace 'pytest-3' 'pytest'

    substituteInPlace systemd/org.freedesktop.secrets.service \
      --replace "/bin/false" "${coreutils}/bin/false"
    substituteInPlace systemd/dbus-org.freedesktop.secrets.service \
      --replace "/usr/local" "$out"
  '';

  postInstall = ''
    mkdir -p "$out/share/dbus-1/services/" "$out/lib/systemd/user/"
    cp systemd/org.freedesktop.secrets.service "$out/share/dbus-1/services/"
    cp systemd/dbus-org.freedesktop.secrets.service "$out/lib/systemd/user/"
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

  checkTarget = "test";

  passthru.tests.pass-secret-service = nixosTests.pass-secret-service;

  meta = {
    description = "Libsecret D-Bus API with pass as the backend";
    homepage = "https://github.com/mdellweg/pass_secret_service/";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ jluttine aidalgol ];
  };
}
