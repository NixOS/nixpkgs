{
  lib,
  stdenv,
  fetchFromGitLab,
  runCommand,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "protopedal";
  version = "2.5";

  src = fetchFromGitLab {
    owner = "openirseny";
    repo = "protopedal";
    tag = "release-${finalAttrs.version}";
    hash = "sha256-3I7tpvqEE6IcWkKlRyCTF6J3+okyHwjC9ddylcU6PlE=";
  };

  installPhase = ''
    runHook preInstall
    install -D protopedal -t $out/bin/
    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests.help = runCommand {
      name = "${finalAttrs.finalPackage}-help-test";
      nativeBuildInputs = [ finalAttrs.finalPackage ];
      script = ''
        protopedal --help
        touch $out
      '';
    };
  };

  meta = {
    description = "Compatibility tool for sim racing pedals and force feedback steering wheels";
    longDescription = ''
      Helps with wheel and pedal detection by creating virtual devices
      with extended capabilities. Facilitates merging devices, range
      adjustments, custom curves, button to axis and axis to button
      mappings.
    '';
    license = lib.licenses.eupl12;
    homepage = "https://gitlab.com/openirseny/protopedal";
    platforms = lib.platforms.all;
    badPlatforms = lib.platforms.darwin;
    maintainers = [ lib.maintainers.rake5k ];
    mainProgram = "protopedal";
  };
})
