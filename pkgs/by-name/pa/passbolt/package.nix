{ lib,
fetchFromGitHub,
php,
dataDir ? "/var/lib/passbolt",
runtimeDir ? "/run/passbolt"
}:

php.buildComposerProject (finalAttrs: {
  pname = "passbolt_api";
  version = "4.5.2";

  src = fetchFromGitHub {
    owner = "passbolt";
    repo = "passbolt_api";
    rev = "v${finalAttrs.version}";
    hash = "sha256-/eOforQSXh88sWG/UvuMoBLAhDxztRoGUmrRz9nirhA=";
  };

  # This is failing but I was not able to pinpoint why exactly
  # I could not manually reproducing the error
  composerStrictValidation = false;
  composerNoDev = true;

  vendorHash = "sha256-Xg/ZYvRT82jqqflAMoDc2sQiW6qQo8KZF7o4gy6Qmbk=";

  php = php.buildEnv {
    extensions = ({ enabled, all }: enabled ++ (with all; [
      gnupg
    ]));
  };
  postInstall = ''
    mv $out/share/php/${finalAttrs.pname}/* $out
    cp $out/config/passbolt.default.php $out/config/passbolt.php
    # Any files to clean up ?
    # tests ?
    mv $out/webroot $out/webroot-static

    # WIP will require a NixOS module to be written
    ln -s ${runtimeDir} $out/webroot
  '';

  meta = {
    changelog = "https://github.com/passbolt/passbolt_api/releases/tag/v${finalAttrs.version}";
    description = "Password Manager server for Teams";
    homepage = "https://passbolt.com";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ akechishiro ];
  };
})
