{
  makeSetupHook,
  onlyBin,
  writeDarwinBundle,
  librsvg,
  imagemagick,
  python3Packages,
}:

makeSetupHook {
  name = "desktop-to-darwin-bundle-hook";
  propagatedBuildInputs = [
    writeDarwinBundle
    librsvg
    imagemagick
    (onlyBin python3Packages.icnsutil)
  ];
} ./hook.sh
