{
  makeSetupHook,
  zip,
}:
makeSetupHook {
  name = "navidrome-plugin-install-hook";
  __structuredAttrs = true;

  propagatedBuildInputs = [
    zip
  ];
} ./install-phase.sh
