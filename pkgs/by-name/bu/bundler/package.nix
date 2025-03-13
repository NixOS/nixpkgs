{
  lib,
  buildRubyGem,
  ruby,
  writeScript,
  testers,
  bundler,
  versionCheckHook,
}:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "bundler";
  version = "2.6.2";
  source.sha256 = "sha256-S4l1bhsFOQ/2eEkRGaEPCXOiBFzJ/LInsCqTlrKPfXQ=";
  dontPatchShebangs = true;

  postFixup = ''
    substituteInPlace $out/bin/bundle --replace-fail "activate_bin_path" "bin_path"
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/bundler";
  versionCheckProgramArg = [ "--version" ];
  doInstallCheck = true;

  passthru = {
    updateScript = writeScript "gem-update-script" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p curl common-updater-scripts jq

      set -eu -o pipefail

      latest_version=$(curl -s https://rubygems.org/api/v1/gems/${gemName}.json | jq --raw-output .version)
      update-source-version ${gemName} "$latest_version"
    '';
    tests.version = testers.testVersion {
      package = bundler;
      command = "bundler -v";
      version = version;
    };
  };

  meta = {
    description = "Manage your Ruby application's gem dependencies";
    homepage = "https://bundler.io";
    changelog = "https://github.com/rubygems/rubygems/blob/bundler-v${version}/bundler/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ anthonyroussel ];
    mainProgram = "bundler";
  };
}
