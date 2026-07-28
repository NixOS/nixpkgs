{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  writeText,
  shellspec,
  # usage:
  # pkgs.mommy.override {
  #  mommySettings.sweetie = "catgirl";
  # }
  #
  # $ mommy
  # who's my good catgirl~
  mommySettings ? null,
}:

let
  variables = lib.mapAttrs' (
    name: value: lib.nameValuePair "MOMMY_${lib.toUpper name}" value
  ) mommySettings;
  configFile = writeText "mommy-config" (lib.toShellVars variables);
in
stdenv.mkDerivation (finalAttrs: {
  pname = "mommy";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "FWDekker";
    repo = "mommy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zuFiRzM3mDt5GIaRl9nCLH3YteJfKtV2R29JwIKygjY=";
  };

  nativeBuildInputs = [ makeWrapper ];
  nativeCheckInputs = [ shellspec ];
  installFlags = [ "prefix=$(out)" ];

  doCheck = true;
  checkTarget = "test/unit";

  postInstall = ''
    ${lib.optionalString (mommySettings != null) ''
      wrapProgram $out/bin/mommy \
        --set-default MOMMY_OPT_CONFIG_FILE "${configFile}"
    ''}
  '';

  meta = {
    description = "mommy's here to support you, in any shell, on any system~ ❤️";
    homepage = "https://github.com/FWDekker/mommy";
    changelog = "https://github.com/FWDekker/mommy/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.unlicense;
    platforms = lib.platforms.all;
    maintainers = [ ];
    mainProgram = "mommy";
  };
})
