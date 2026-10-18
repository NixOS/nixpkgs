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

  ai-assistant = mkBulwarkPlugin (finalAttrs: {
    pname = "bulwark-plugin-ai-assistant";
    version = "2.1.2";
    src = fetchFromGitHub {
      owner = "bulwarkmail";
      repo = "plugins";
      tag = "ai-assistant@${finalAttrs.version}";
      hash = "sha256-Ub4GEPVnWynzgBgYv0eDx1xdG/ab0g+iATs+S08BW/U=";
    };
    sourceRoot = "${finalAttrs.src.name}/ai-assistant";
    npmDepsHash = "sha256-5EYEYLuvBYTRwoIafZIYo0COju/TpwK5KqPTKUlW+QE=";
    meta = {
      description = "Write, rewrite, translate and proofread emails, and summarise messages, with an OpenAI-compatible service (OpenAI, Ollama, ...) or Anthropic";
      homepage = "https://extensions.bulwarkmail.org/extension/ai-assistant";
      license = lib.licenses.agpl3Only;
      maintainers = with lib.maintainers; [ Cameo007 ];
    };
  });
  auto-tag = mkBulwarkPlugin (finalAttrs: {
    pname = "bulwark-plugin-auto-tag";
    version = "1.3.1";
    src = fetchFromGitHub {
      owner = "bulwarkmail";
      repo = "plugins";
      tag = "auto-tag@${finalAttrs.version}";
      hash = "sha256-gOVKR/ZqB1tUUqdxdnhmHQjEruJaRBpRT/ZuoAwROwo=";
    };
    sourceRoot = "${finalAttrs.src.name}/auto-tag";
    npmDepsHash = "sha256-gy/RmzwoOzoE0wIjzbFOECzLUTCioMdX58oFlaH760A=";
    meta = {
      description = "Automatically tags incoming emails based on configurable rules";
      homepage = "https://extensions.bulwarkmail.org/extension/auto-tag";
      license = lib.licenses.agpl3Only;
      maintainers = with lib.maintainers; [ Cameo007 ];
    };
  });
  birthdays = mkBulwarkPlugin (finalAttrs: {
    pname = "bulwark-plugin-birthdays";
    version = "1.1.1";
    src = fetchFromGitHub {
      owner = "bulwarkmail";
      repo = "plugins";
      tag = "birthdays@${finalAttrs.version}";
      hash = "sha256-vHIuhb0IMBveJ8WrKeunWRGB9XEtb85qKCs5mW68ls0=";
    };
    sourceRoot = "${finalAttrs.src.name}/birthdays";
    npmDepsHash = "sha256-FmeI4FHbuhSXwowWmgfZ821Q0E+0kcNYb/oWozYSG+g=";
    meta = {
      description = "Upcoming birthdays from your contacts in the sidebar, reminders on the day and a few days before, a quick birthday greeting and, if you like, birthday events in your calendar";
      homepage = "https://extensions.bulwarkmail.org/extension/birthdays";
      license = lib.licenses.agpl3Only;
      maintainers = with lib.maintainers; [ Cameo007 ];
    };
  });
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
  email-stats = mkBulwarkPlugin (finalAttrs: {
    pname = "bulwark-plugin-email-stats";
    version = "1.3.1";
    src = fetchFromGitHub {
      owner = "bulwarkmail";
      repo = "plugins";
      tag = "email-stats@${finalAttrs.version}";
      hash = "sha256-VRMzefuazteAcGGJD9I2Dr16aQBHrlxnp+ePA1WOyvw=";
    };
    sourceRoot = "${finalAttrs.src.name}/email-stats";
    npmDepsHash = "sha256-IGfG/k7TuXr6uOQR87mLB712DJ4O93LmlzErdQQQ6NU=";
    meta = {
      description = "Sidebar section showing email activity statistics";
      homepage = "https://extensions.bulwarkmail.org/extension/email-stats";
      license = lib.licenses.agpl3Only;
      maintainers = with lib.maintainers; [ Cameo007 ];
    };
  });
  email-to-task = mkBulwarkPlugin (finalAttrs: {
    pname = "bulwark-plugin-email-to-task";
    version = "1.1.1";
    src = fetchFromGitHub {
      owner = "bulwarkmail";
      repo = "plugins";
      tag = "email-to-task@${finalAttrs.version}";
      hash = "sha256-u4jbmIvYYzw4ofvnwvpMofAiNx7rUA1c07Q2G2O6xAc=";
    };
    sourceRoot = "${finalAttrs.src.name}/email-to-task";
    npmDepsHash = "sha256-PSKbV5s3PDPKvB7lgj88B2H6lIBzFODdN2LLDVRlErc=";
    meta = {
      description = "Turn a message into a task in Bulwark's own tasks, Vikunja, Todoist or a CalDAV task list, with a link back to the message and a due date taken from the text";
      homepage = "https://extensions.bulwarkmail.org/extension/email-to-task";
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
  external-recipient-warning = mkBulwarkPlugin (finalAttrs: {
    pname = "bulwark-plugin-external-recipient-warning";
    version = "1.1.1";
    src = fetchzip {
      url = "https://extensions.bulwarkmail.org/api/v1/bundle/external-recipient-warning/${finalAttrs.version}";
      hash = "sha256-VpDlaYj8LQqlMnLZrkfmta+siUf6lzhoqzUiI4cksiU=";
      extension = "zip";
      stripRoot = false;
    };
    meta = {
      description = "Warns before sending email to recipients outside your safe-domain list, and flags incoming messages from external senders with a banner";
      homepage = "https://extensions.bulwarkmail.org/extension/external-recipient-warning";
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
  nextcloud = mkBulwarkPlugin (finalAttrs: {
    pname = "bulwark-plugin-nextcloud";
    version = "1.2.0";
    src = fetchFromGitHub {
      owner = "bulwarkmail";
      repo = "plugins";
      tag = "nextcloud@${finalAttrs.version}";
      hash = "sha256-71wVockV+b3jfIFugaTYKXMYUTJoKxNpeYGs/5xkpc0=";
    };
    sourceRoot = "${finalAttrs.src.name}/nextcloud";
    npmDepsHash = "sha256-baP+SMh9kWizeOAsg1Y+O6TieEJ/sXuwDfDFUvEAImY=";
    meta = {
      description = "Connect your Nextcloud: attach files from it, send large files as share links, and save attachments and messages to it";
      homepage = "https://extensions.bulwarkmail.org/extension/nextcloud";
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
  outlook-style-headers = mkBulwarkPlugin (finalAttrs: {
    pname = "bulwark-plugin-outlook-style-headers";
    version = "1.2.2";
    src = fetchFromGitHub {
      owner = "bulwarkmail";
      repo = "plugins";
      tag = "outlook-style-headers@${finalAttrs.version}";
      hash = "sha256-r2rhl++0+pCl3ims5D98VVU4e067/p43XoNNL0xOZYk=";
    };
    sourceRoot = "${finalAttrs.src.name}/outlook-style-headers";
    npmDepsHash = "sha256-Xi5cWiRgjqh6dPFpEYcfGw09dzSyFGckzg8wrDKdWYk=";
    meta = {
      description = "Replaces the default reply/forward quote header with an Outlook-style From / Sent / To / Cc / Subject block";
      homepage = "https://extensions.bulwarkmail.org/extension/outlook-style-headers";
      license = lib.licenses.agpl3Only;
      maintainers = with lib.maintainers; [ Cameo007 ];
    };
  });
  paperless = mkBulwarkPlugin (finalAttrs: {
    pname = "bulwark-plugin-paperless";
    version = "1.2.0";
    src = fetchFromGitHub {
      owner = "bulwarkmail";
      repo = "plugins";
      tag = "paperless@${finalAttrs.version}";
      hash = "sha256-ndEpeNC3Ml9qwoqjv2Z17a1kfputA5I1iw5qnWQIHqo=";
    };
    sourceRoot = "${finalAttrs.src.name}/paperless";
    npmDepsHash = "sha256-roCzUou33DRvO+LgwXq6n/VxNR4V3zH1tE38vlCizEg=";
    meta = {
      description = "Send attachments and messages to Paperless-ngx, find your documents there and attach them to new mail";
      homepage = "https://extensions.bulwarkmail.org/extension/paperless";
      license = lib.licenses.agpl3Only;
      maintainers = with lib.maintainers; [ Cameo007 ];
    };
  });
  parcels = mkBulwarkPlugin (finalAttrs: {
    pname = "bulwark-plugin-parcels";
    version = "1.2.1";
    src = fetchFromGitHub {
      owner = "bulwarkmail";
      repo = "plugins";
      tag = "parcels@${finalAttrs.version}";
      hash = "sha256-ndEpeNC3Ml9qwoqjv2Z17a1kfputA5I1iw5qnWQIHqo=";
    };
    sourceRoot = "${finalAttrs.src.name}/parcels";
    npmDepsHash = "sha256-pmiS802GTT4vfXqyVo/jd+TFoOVL/BC3mVkOy5KHtQM=";
    meta = {
      description = "Finds tracking numbers in your mail, shows where each parcel is and tells you when its status changes";
      homepage = "https://extensions.bulwarkmail.org/extension/parcels";
      license = lib.licenses.agpl3Only;
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
  quarantine-release = mkBulwarkPlugin (finalAttrs: {
    pname = "bulwark-plugin-quarantine-release";
    version = "1.3.0";
    src = fetchFromGitHub {
      owner = "dealerweb";
      repo = "bulwark-quarantine-plugin";
      tag = "v${finalAttrs.version}";
      hash = "sha256-srlARixtwInkQ5lrQwrlRIkqfor3eqf111rzx7nCFjE=";
    };
    meta = {
      description = "Delivers mail from a quarantine account to its original recipients again, with the subject as the sender wrote it and without the spam headers";
      homepage = "https://github.com/dealerweb/bulwark-quarantine-plugin";
      license = lib.licenses.agpl3Only;
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
  reply-all-guardrail = mkBulwarkPlugin (finalAttrs: {
    pname = "bulwark-plugin-reply-all-guardrail";
    version = "1.3.1";
    src = fetchFromGitHub {
      owner = "bulwarkmail";
      repo = "plugins";
      tag = "reply-all-guardrail@${finalAttrs.version}";
      hash = "sha256-DPUntREHydMOn1h8Gp3AfD+OOLYpfdn24FkglDl+Hd4=";
    };
    sourceRoot = "${finalAttrs.src.name}/reply-all-guardrail";
    npmDepsHash = "sha256-1EDpHcjQyHgZgmSzzO9NbU99acVfUgsJ4o19XItGOs0=";
    meta = {
      description = "Asks for confirmation before reply-all (and optionally before any send) when the recipient count crosses a threshold";
      homepage = "https://extensions.bulwarkmail.org/extension/reply-all-guardrail";
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
  team-inbox = mkBulwarkPlugin (finalAttrs: {
    pname = "bulwark-plugin-team-inbox";
    version = "1.0.0";
    src = fetchFromGitHub {
      owner = "bulwarkmail";
      repo = "plugins";
      tag = "team-inbox@${finalAttrs.version}";
      hash = "sha256-Vl2XlkWVSSeHwX/CGTsw9MD6a5QjlvQ345WeV3ZGLNc=";
    };
    sourceRoot = "${finalAttrs.src.name}/team-inbox";
    npmDepsHash = "sha256-RoZF5Kby1iElqXY+SL9SBDp8LP2lTnQpXCgs3TYUvYc=";
    meta = {
      description = "Assign messages in a team mailbox (a Stalwart group account) to a member and mark them done";
      homepage = "https://extensions.bulwarkmail.org/extension/team-inbox";
      license = lib.licenses.agpl3Only;
      maintainers = with lib.maintainers; [ Cameo007 ];
    };
  });
  timezones = mkBulwarkPlugin (finalAttrs: {
    pname = "bulwark-plugin-timezones";
    version = "1.1.1";
    src = fetchFromGitHub {
      owner = "bulwarkmail";
      repo = "plugins";
      tag = "timezones@${finalAttrs.version}";
      hash = "sha256-aIxfF82wpxwwaIA2ETXsGgu3o3aUzvaVjImEA9b2y1g=";
    };
    sourceRoot = "${finalAttrs.src.name}/timezones";
    npmDepsHash = "sha256-FiFpceQ0jftozFn1ydl12YnWOdpuW+lyVL9Nmxf/W9g=";
    meta = {
      description = "Shows the time where the people you write to are";
      homepage = "https://extensions.bulwarkmail.org/extension/timezones";
      license = lib.licenses.agpl3Only;
      maintainers = with lib.maintainers; [ Cameo007 ];
    };
  });
  translate = mkBulwarkPlugin (finalAttrs: {
    pname = "bulwark-plugin-translate";
    version = "1.5.2";
    src = fetchFromGitHub {
      owner = "bulwarkmail";
      repo = "plugins";
      tag = "translate@${finalAttrs.version}";
      hash = "sha256-jsNtV+AxcDd/GBbUa6eUZzyaLl6OzXAt/kOONTeePmM=";
    };
    sourceRoot = "${finalAttrs.src.name}/translate";
    npmDepsHash = "sha256-SNWjCuELkOklJJqDYu6Yog4lJLpsQ7MtqybLTalppLA=";
    meta = {
      description = "Translate received emails into your preferred language using a free public translation API (MyMemory by default, LibreTranslate optional)";
      homepage = "https://extensions.bulwarkmail.org/extension/translate";
      license = lib.licenses.agpl3Only;
      maintainers = with lib.maintainers; [ Cameo007 ];
    };
  });
}
