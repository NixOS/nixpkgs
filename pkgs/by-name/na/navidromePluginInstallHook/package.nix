{
  makeSetupHook,
  zip,
}:
makeSetupHook {
  name = "navidrome-plugin-install-hook";

  propagatedBuildInputs = [
    zip
  ];
} ./install-phase.sh
