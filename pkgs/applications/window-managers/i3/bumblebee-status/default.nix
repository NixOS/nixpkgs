{
  pkgs,
  lib,
  glibcLocales,
  python,
  fetchFromGitHub,
  # Usage: bumblebee-status.override { plugins = p: [p.arandr p.bluetooth2]; };
  plugins ? p: [ ],
}:
let
  version = "2.2.0";

  # { <name> = { name = "..."; propagatedBuildInputs = [ ... ]; buildInputs = [ ... ]; } }
  allPlugins = lib.mapAttrs (name: value: value // { inherit name; }) (
    import ./plugins.nix { inherit pkgs python; }
  );

  # [ { name = "..."; propagatedBuildInputs = [ ... ]; buildInputs = [ ... ]; } ]
  selectedPlugins = plugins allPlugins;
in
python.pkgs.buildPythonPackage {
  pname = "bumblebee-status";
  inherit version;

  src = fetchFromGitHub {
    owner = "tobi-wan-kenobi";
    repo = "bumblebee-status";
    rev = "v${version}";
    hash = "sha256-+RCg2XZv0AJnexi7vnQhEXB1qSoKBN1yKWm3etdys1s=";
  };

  buildInputs = lib.concatMap (p: p.buildInputs or [ ]) selectedPlugins;
  propagatedBuildInputs = lib.concatMap (p: p.propagatedBuildInputs or [ ]) selectedPlugins;

  checkInputs = with python.pkgs; [
    freezegun
    netifaces
    psutil
    pytest
    pytest-mock
    requests
  ];

  checkPhase = ''
    runHook preCheck

    # Fixes `locale.Error: unsupported locale setting` in some tests.
    export LOCALE_ARCHIVE="${glibcLocales}/lib/locale/locale-archive";

    # FIXME: We skip the `dunst` module tests, some of which fail with
    # `RuntimeError: killall -s SIGUSR2 dunst not found`.
    # This is not solved by adding `pkgs.killall` to `checkInputs`.
    ${python.interpreter} -m pytest -k 'not test_dunst.py'

    runHook postCheck
  '';

  postInstall = ''
    # Remove binary cache files
    find $out -name "__pycache__" -type d | xargs rm -rv

    # Make themes available for bumblebee-status to detect them
    cp -r ./themes $out/${python.sitePackages}
  '';

  meta = with lib; {
    description = "A modular, theme-able status line generator for the i3 window manager";
    homepage = "https://github.com/tobi-wan-kenobi/bumblebee-status";
    mainProgram = "bumblebee-status";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ augustebaum ];
  };
}
