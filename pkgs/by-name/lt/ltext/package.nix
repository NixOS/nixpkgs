{
  lib,
  rustPlatform,
  fetchFromGitHub,
  runCommand,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ltext";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "ltext";
    repo = "ltext";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BZHz/8oiv6eBMqwLlqf50gcTjsdDWX4q0ZORybryzrM=";
  };

  cargoHash = "sha256-kLoSzSgzK7QpRsYFfggmURmFxOLk7mf4UPryeIAwSNk=";

  __structuredAttrs = true;

  # Besides the unit and property tests, run the CLI golden test corpus.
  postCheck = ''
    patchShebangs golden/run.sh
    golden/run.sh target/*/$cargoBuildType/ltext
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
    # Render a template with the installed binary.
    tests.render =
      runCommand "ltext-test-render" { nativeBuildInputs = [ finalAttrs.finalPackage ]; }
        ''
          printf '{{ name }}\nHello,\n{{ name }}\n' > greeting
          printf 'World\n' > name
          ltext 'greeting name' > out
          printf 'Hello,\nWorld\n' | diff - out
          [ "$(ltext --type greeting)" = 'Text -> Text' ]
          touch $out
        '';
  };

  meta = {
    description = "Text-file templating utility that treats files as higher-order functions";
    homepage = "https://github.com/ltext/ltext";
    changelog = "https://github.com/ltext/ltext/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ athanclark ];
    mainProgram = "ltext";
  };
})
