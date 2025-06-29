{
  lib,
  fetchFromGitHub,
  php,
  bash,
  imagemagick,
  zlib,
  makeWrapper,
  dataDir ? "/var/lib/passbolt",
  runtimeDir ? "/run/passbolt",
}:

let
  phpWithExt = php.buildEnv {
    extensions = (
      { all, enabled }:
      enabled
      ++ (with all; [
        gnupg
        xsl
        imagick
        openssl
        curl
      ])
    );
  };
in
php.buildComposerProject (finalAttrs: {
  pname = "passbolt_api";
  version = "4.9.1";

  src = fetchFromGitHub {
    owner = "passbolt";
    repo = "passbolt_api";
    rev = "v${finalAttrs.version}";
    hash = "sha256-C8vx3a+HFoRPCxK9drgWco6x0sPZzxgGK+dChTRTKUw=";
  };

  composerStrictValidation = false;
  composerNoDev = true;

  vendorHash = "sha256-p0yMAwsfWFunPh43YQq+u9JjbWoV12KNjYO49zeqYYY=";

  php = phpWithExt;

  postInstall = ''
    mv $out/share/php/${finalAttrs.pname}/* $out
    cp $out/config/passbolt.default.php $out/config/passbolt.php
    cp $out/config/app.default.php $out/config/app.php

    ## [WIP] Install process requires lot of patching ##
    patchShebangs $out/bin/*
    substituteInPlace $out/bin/cake --replace-fail "/usr/local/bin/php" "${lib.makeBinPath [ phpWithExt ]}/php"
    substituteInPlace $out/bin/cake.php --replace-fail "dirname(__DIR__)" "\"$out\""
    # TODO: Need to patch tmp directory/cache directory to where ??
    # Need to patch logs directory out of nix store to where ??

    # TODO: handle or declare Env variable for initial configuration ?
    # Any files to clean up/useless ?
    # tests ?
    mv $out/webroot $out/webroot-static

    # WIP will require a NixOS module to be written
    ln -s ${runtimeDir} $out/webroot
  '';
  # TODO: Maybe assert that this isn't failing, maybe shouldn't be done here and inside nixos test framework better testing can be done
  postInstallCheck = ''
    ${bash}/bin/bash "$out/bin/cake passbolt install"
  '';

  meta = {
    changelog = "https://github.com/passbolt/passbolt_api/releases/tag/v${finalAttrs.version}";
    description = "Password Manager server for Teams";
    homepage = "https://passbolt.com";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ ];
  };
})
