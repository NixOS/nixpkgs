{
  lib,
  stdenvNoCC,
  buildNpmPackage,
  fetchFromGitHub,
  fetchzip,
  nix-update,
  nix-update-script,
  writeShellScript,
  curl,
  jq,
  coreutils,
}:
let
  # Store bundles ship a prebuilt index.js. Source checkouts (with
  # npmDepsHash) need to be built with npm first.
  mkBulwarkPlugin =
    f:
    let
      fromSource = (lib.fix f) ? npmDepsHash;
      builder = if fromSource then buildNpmPackage else stdenvNoCC.mkDerivation;
    in
    builder (
      finalAttrs:
      let
        attrs = f finalAttrs;
      in
      attrs
      // rec {
        pluginName = lib.removePrefix "bulwark-plugin-" attrs.pname;

        strictDeps = true;

        installPhase = ''
          runHook preInstall

          install -Dm644 -t $out manifest.json ${if fromSource then "dist/" else ""}index.js
          if [ -d media ]; then
            cp -r media $out/
          fi

          runHook postInstall
        '';

        # nix-update cannot discover versions on the extension store, so ask
        # its API for the latest one and let nix-update fix the hashes.
        passthru.updateScript =
          if fromSource then
            nix-update-script { }
          else
            writeShellScript "update-${attrs.pname}" ''
              set -euo pipefail
              version=$(${lib.getExe curl} -sSf https://extensions.bulwarkmail.org/api/v1/extension/${pluginName} \
                | ${lib.getExe jq} -r '.data.versions[].version' \
                | ${coreutils}/bin/sort -V | ${coreutils}/bin/tail -n1)
              exec ${lib.getExe nix-update} bulwark-plugins.${pluginName} --version="$version"
            '';
      }
    );
in
{

  inherit mkBulwarkPlugin;

  calendar-agenda = mkBulwarkPlugin (finalAttrs: {
    pname = "bulwark-plugin-calendar-agenda";
    version = "1.2.1";
    src = fetchzip {
      url = "https://extensions.bulwarkmail.org/api/v1/bundle/calendar-agenda/${finalAttrs.version}";
      hash = "sha256-p6RIndNGifU70JadAbWmTT5RE2kOgEVmXKCaa6CkFp0=";
      extension = "zip";
      stripRoot = false;
    };
    meta = {
      description = "Shows an agenda of your upcoming calendar events in the sidebar";
      homepage = "https://extensions.bulwarkmail.org/extension/calendar-agenda";
      license = lib.licenses.agpl3Only;
      maintainers = with lib.maintainers; [ Cameo007 ];
    };
  });
  external-link-warning = mkBulwarkPlugin (finalAttrs: {
    pname = "bulwark-plugin-external-link-warning";
    version = "1.2.1";
    src = fetchzip {
      url = "https://extensions.bulwarkmail.org/api/v1/bundle/external-link-warning/${finalAttrs.version}";
      hash = "sha256-FHq3l5yhVpwcgzbXMI7L5l6+wVwRODm56SJSFQuaRAY=";
      extension = "zip";
      stripRoot = false;
    };
    meta = {
      description = "Warns before opening external links to unknown domains";
      homepage = "https://extensions.bulwarkmail.org/extension/external-link-warning";
      license = lib.licenses.agpl3Only;
      maintainers = with lib.maintainers; [ Cameo007 ];
    };
  });
  external-mail-warning = mkBulwarkPlugin (finalAttrs: {
    pname = "bulwark-plugin-external-mail-warning";
    version = "1.3.1";
    src = fetchzip {
      url = "https://extensions.bulwarkmail.org/api/v1/bundle/external-mail-warning/${finalAttrs.version}";
      hash = "sha256-J0+WCqc8GGw8txZ1g/4JhnivcLA5iuZOQdlXuUSJMxA=";
      extension = "zip";
      stripRoot = false;
    };
    meta = {
      description = "Warns before sending email to recipients outside your safe-domain list";
      homepage = "https://extensions.bulwarkmail.org/extension/external-mail-warning";
      license = lib.licenses.agpl3Only;
      maintainers = with lib.maintainers; [ Cameo007 ];
    };
  });
  gravatar = mkBulwarkPlugin (finalAttrs: {
    pname = "bulwark-plugin-gravatar";
    version = "1.3.1";
    src = fetchzip {
      url = "https://extensions.bulwarkmail.org/api/v1/bundle/gravatar/${finalAttrs.version}";
      hash = "sha256-Rz+xgBw4mfQcdGvQnPLrrW5i4nDQYwMt5Y37gZ2WxyE=";
      extension = "zip";
      stripRoot = false;
    };
    meta = {
      description = "Resolves Gravatar profile pictures for email contacts via the avatar transform hook";
      homepage = "https://extensions.bulwarkmail.org/extension/gravatar";
      license = lib.licenses.agpl3Only;
      maintainers = with lib.maintainers; [ Cameo007 ];
    };
  });
  impersonation-notice = mkBulwarkPlugin (finalAttrs: {
    pname = "bulwark-plugin-impersonation-notice";
    version = "1.2.5";
    src = fetchzip {
      url = "https://extensions.bulwarkmail.org/api/v1/bundle/impersonation-notice/${finalAttrs.version}";
      hash = "sha256-BuE+51gOAMFAsfrRK8O+1SNJ2G/L1NQ9WBYZZq7tlko=";
      extension = "zip";
      stripRoot = false;
    };
    meta = {
      description = "Shows a persistent top-of-app banner when the active session is a Stalwart master-user impersonation";
      homepage = "https://extensions.bulwarkmail.org/extension/impersonation-notice";
      license = lib.licenses.agpl3Only;
      maintainers = with lib.maintainers; [ Cameo007 ];
    };
  });
  jitsi-meet = mkBulwarkPlugin (finalAttrs: {
    pname = "bulwark-plugin-jitsi-meet";
    version = "1.0.1";
    src = fetchzip {
      url = "https://extensions.bulwarkmail.org/api/v1/bundle/jitsi-meet/${finalAttrs.version}";
      hash = "sha256-8HYA5Ihi3D9ia4RxxM/J3lfB1qxB3LDyVYx4TDTNSJo=";
      extension = "zip";
      stripRoot = false;
    };
    meta = {
      description = "Adds a 'Add Jitsi Meeting' button to calendar events";
      homepage = "https://extensions.bulwarkmail.org/extension/jitsi-meet";
      license = lib.licenses.agpl3Only;
      maintainers = with lib.maintainers; [ Cameo007 ];
    };
  });
  libravatar = mkBulwarkPlugin (finalAttrs: {
    pname = "bulwark-plugin-libravatar";
    version = "1.0.0";
    src = fetchzip {
      url = "https://extensions.bulwarkmail.org/api/v1/bundle/libravatar/${finalAttrs.version}";
      hash = "sha256-R0AfJJv6IjeFyFUN4L4JA25VvrkLYb1FFAo5IMqxQzU=";
      extension = "zip";
      stripRoot = false;
    };
    meta = {
      description = "Resolves Libravatar profile pictures for email contacts via the avatar transform hook";
      homepage = "https://extensions.bulwarkmail.org/extension/libravatar";
      license = lib.licenses.agpl3Only;
      maintainers = with lib.maintainers; [ Cameo007 ];
    };
  });
  openpgp = mkBulwarkPlugin (finalAttrs: {
    pname = "bulwark-plugin-openpgp";
    version = "1.1.6";
    src = fetchFromGitHub {
      owner = "samuelmiller36";
      repo = "bulwark-gpg";
      tag = "v${finalAttrs.version}";
      hash = "sha256-/n5FroXla8MvkVZJvPDIZcxm498hIInCJRIbAt9/LMQ=";
    };
    npmDepsHash = "sha256-rIPl4HIETiZjnfDwORf/lauqN/nbVjLy0a29nm3+bHo=";
    meta = {
      description = "End-to-end OpenPGP (GnuPG-compatible) for webmail";
      homepage = "https://github.com/samuelmiller36/bulwark-gpg";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [ Cameo007 ];
    };
  });
  pgp-true-end-to-end = mkBulwarkPlugin (finalAttrs: {
    pname = "bulwark-plugin-pgp-true-end-to-end";
    version = "2.0.0";
    src = fetchFromGitHub {
      owner = "paulhenry46";
      repo = "pgp-plugin";
      tag = finalAttrs.version;
      hash = "sha256-VFX6kiOf0UclAT1Tntg3vmfBUK5Kevh0Vq57XEizcWA=";
    };
    npmDepsHash = "sha256-O84i5VyIJ+MlhQAJhXRjmlzmwPl910HTFwFWg/vzrUE=";
    meta = {
      description = "End-to-end OpenPGP for webmail";
      homepage = "https://github.com/paulhenry46/pgp-plugin";
      license = lib.licenses.gpl3Plus;
      maintainers = with lib.maintainers; [ Cameo007 ];
    };
  });
  quick-notes = mkBulwarkPlugin (finalAttrs: {
    pname = "bulwark-plugin-quick-notes";
    version = "1.0.0";
    src = fetchzip {
      url = "https://extensions.bulwarkmail.org/api/v1/bundle/quick-notes/${finalAttrs.version}";
      hash = "sha256-Hh9tTuL0OGSxZWUj2seYD6038ny1DubInpSdtAntOgU=";
      extension = "zip";
      stripRoot = false;
    };
    meta = {
      description = "Per-email sticky notes in the sidebar — jot notes while reading emails";
      homepage = "https://extensions.bulwarkmail.org/extension/quick-notes";
      license = lib.licenses.agpl3Only;
      maintainers = with lib.maintainers; [ Cameo007 ];
    };
  });
  smime = mkBulwarkPlugin (finalAttrs: {
    pname = "bulwark-plugin-smime";
    version = "1.0.2";
    src = fetchzip {
      url = "https://extensions.bulwarkmail.org/api/v1/bundle/smime/${finalAttrs.version}";
      hash = "sha256-BGOOkZu3EHCo4uM+g4B81B+6BoXGLlq++hfbevfpWVc=";
      extension = "zip";
      stripRoot = false;
    };
    meta = {
      description = "End-to-end S/MIME for webmail";
      homepage = "https://extensions.bulwarkmail.org/extension/smime";
      license = lib.licenses.agpl3Only;
      maintainers = with lib.maintainers; [ Cameo007 ];
    };
  });
  spam-score = mkBulwarkPlugin (finalAttrs: {
    pname = "bulwark-plugin-spam-score";
    version = "1.0.0";
    src = fetchzip {
      url = "https://extensions.bulwarkmail.org/api/v1/bundle/spam-score/${finalAttrs.version}";
      hash = "sha256-JmT/r4Xhn9NiiAnPfya6EqWvpW3wpJFXjNpzmznMDcE=";
      extension = "zip";
      stripRoot = false;
    };
    meta = {
      description = "Adds a Spam Analysis section to a message's \"More details\" panel";
      homepage = "https://extensions.bulwarkmail.org/extension/spam-score";
      license = lib.licenses.agpl3Only;
      maintainers = with lib.maintainers; [ Cameo007 ];
    };
  });
}
