{ lib, python3Packages, fetchFromGitHub
, withGui ? false, wrapQtAppsHook ? null }:

python3Packages.buildPythonApplication rec {
  pname = "maestral${lib.optionalString withGui "-gui"}";
  version = "0.2.6";

  src = fetchFromGitHub {
    owner = "SamSchott";
    repo = "maestral-dropbox";
    rev = "v${version}";
    sha256 = "1nfjm58f6hnqbx9xnz2h929s2175ka1yf5jjlk4i60v0wppnrrdf";
  };

  disabled = python3Packages.pythonOlder "3.6";

  propagatedBuildInputs = (with python3Packages; [
    blinker click dropbox keyring keyrings-alt requests u-msgpack-python watchdog
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
