{ stdenv, lib, python3Packages, fetchFromGitHub
, withGui ? false, wrapQtAppsHook ? null }:

python3Packages.buildPythonApplication rec {
  pname = "maestral${lib.optionalString withGui "-gui"}";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "SamSchott";
    repo = "maestral-dropbox";
    rev = "v${version}";
    sha256 = "1jjn9cz43850xvs52gvx16qc5z4l91y4kpn6fpl05iwgaisbi1ws";
  };

  disabled = python3Packages.pythonOlder "3.6";

  propagatedBuildInputs = (with python3Packages; [
    blinker click dropbox keyring keyrings-alt Pyro4 requests u-msgpack-python watchdog
  ] ++ lib.optionals stdenv.isLinux [
    sdnotify systemd
  ] ++ lib.optional withGui pyqt5);

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
