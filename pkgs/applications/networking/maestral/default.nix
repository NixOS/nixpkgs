{ stdenv
, lib
, fetchFromGitHub
, python3
, withGui ? false
, wrapQtAppsHook ? null
}:

python3.pkgs.buildPythonApplication rec {
  pname = "maestral${lib.optionalString withGui "-gui"}";
  version = "0.6.1";

  disabled = python3.pkgs.pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "SamSchott";
    repo = "maestral-dropbox";
    rev = "v${version}";
    sha256 = "06i3c7i85x879np158156mba7kxz2cwh75390sc9gwwngc95d9h9";
  };

  propagatedBuildInputs = with python3.pkgs; [
    blinker
    bugsnag
    click
    dropbox
    keyring
    keyrings-alt
    lockfile
    Pyro5
    requests
    u-msgpack-python
    watchdog
  ] ++ lib.optionals stdenv.isLinux [
    sdnotify
    systemd
  ] ++ lib.optional withGui pyqt5;

  nativeBuildInputs = lib.optional withGui wrapQtAppsHook;

  postInstall = lib.optionalString withGui ''
    makeQtWrapper $out/bin/maestral $out/bin/maestral-gui \
      --add-flags gui
  '';

  # no tests
  doCheck = false;

  meta = with lib; {
    description = "Open-source Dropbox client for macOS and Linux";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.unix;
    inherit (src.meta) homepage;
  };
}
