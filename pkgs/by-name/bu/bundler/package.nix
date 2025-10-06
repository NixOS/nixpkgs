{
  lib,
  buildRubyGem,
  ruby,
  writeScript,
  testers,
  bundler,
  versionCheckHook,
  nix-update-script,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "bundler";
  version = "2.7.1";
  source.sha256 = "sha256-CtWgAqh5d2sqmL5lL1V6yHMb4zU2EtY/pO8bJwbcHgs=";
  dontPatchShebangs = true;

  postFixup = ''
    substituteInPlace $out/bin/bundle --replace-fail "activate_bin_path" "bin_path"
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/bundler";
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Manage your Ruby application's gem dependencies";
    homepage = "https://bundler.io";
    changelog = "https://github.com/rubygems/rubygems/blob/bundler-v${version}/bundler/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      anthonyroussel
      guylamar2006
    ];
    mainProgram = "bundler";
  };
}
