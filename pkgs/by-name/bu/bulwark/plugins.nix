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
    version = "2.2.1";
    src = fetchFromGitHub {
      owner = "bulwarkmail";
      repo = "plugins";
      tag = "ai-assistant@${finalAttrs.version}";
      hash = "sha256-8XZO/JdaLJhOzkF7CyI7ZJTpoK9EQ3FLLrdk7ukmSl4=";
    };
    sourceRoot = "${finalAttrs.src.name}/ai-assistant";
    npmDepsHash = "sha256-5mi1oUDh3xO65VGZAS23thhF5bQMOLeE/R2yUNlp6cQ=";
    meta = {
      description = "Write, rewrite, translate and proofread emails, and summarise messages, with an OpenAI-compatible service (OpenAI, Ollama, ...) or Anthropic";
      homepage = "https://extensions.bulwarkmail.org/extension/ai-assistant";
      license = lib.licenses.agpl3Only;
      maintainers = with lib.maintainers; [ Cameo007 ];
    };
  });
  auto-tag = mkBulwarkPlugin (finalAttrs: {
    pname = "bulwark-plugin-auto-tag";
    version = "1.3.2";
    src = fetchFromGitHub {
      owner = "bulwarkmail";
      repo = "plugins";
      tag = "auto-tag@${finalAttrs.version}";
      hash = "sha256-LSfNvFUJ6TNRqihS2kgYqw2oQhdEO7axYlYp6M7fcnQ=";
    };
    sourceRoot = "${finalAttrs.src.name}/auto-tag";
    npmDepsHash = "sha256-vNAx11pC+/EQLY3WOA5M6P+CtK6EuW+pUKknZa/hMbo=";
    meta = {
      description = "Automatically tags incoming emails based on configurable rules";
      homepage = "https://extensions.bulwarkmail.org/extension/auto-tag";
      license = lib.licenses.agpl3Only;
      maintainers = with lib.maintainers; [ Cameo007 ];
    };
  });
  birthdays = mkBulwarkPlugin (finalAttrs: {
    pname = "bulwark-plugin-birthdays";
    version = "1.1.2";
    src = fetchFromGitHub {
      owner = "bulwarkmail";
      repo = "plugins";
      tag = "birthdays@${finalAttrs.version}";
      hash = "sha256-QuFAeUkXh7nr609jviZmSG7WmBr4IA4JZeww/XjGkVU=";
    };
    sourceRoot = "${finalAttrs.src.name}/birthdays";
    npmDepsHash = "sha256-Ya5/fmVi2nPpeQJ2we4P1vt+t/0O/WhVIBlacvnK1lQ=";
    meta = {
      description = "Upcoming birthdays from your contacts in the sidebar, reminders on the day and a few days before, a quick birthday greeting and, if you like, birthday events in your calendar";
      homepage = "https://extensions.bulwarkmail.org/extension/birthdays";
      license = lib.licenses.agpl3Only;
      maintainers = with lib.maintainers; [ Cameo007 ];
    };
  });
  calendar-agenda = mkBulwarkPlugin (finalAttrs: {
    pname = "bulwark-plugin-calendar-agenda";
    version = "1.4.5";
    src = fetchFromGitHub {
      owner = "bulwarkmail";
      repo = "plugins";
      tag = "calendar-agenda@${finalAttrs.version}";
      hash = "sha256-t458d7LNj2AgSygloEvhefr/P309FSS0N1QlHqJjjtI=";
    };
    sourceRoot = "${finalAttrs.src.name}/calendar-agenda";
    npmDepsHash = "sha256-qxNRR4hkE0SXUpE6i2C+tFME5Hal6kzgu6yJsqyf0vU=";
    meta = {
      description = "Shows an agenda of your upcoming calendar events in the sidebar";
      homepage = "https://extensions.bulwarkmail.org/extension/calendar-agenda";
      license = lib.licenses.agpl3Only;
      maintainers = with lib.maintainers; [ Cameo007 ];
    };
  });
  category-tabs = mkBulwarkPlugin (finalAttrs: {
    pname = "bulwark-plugin-category-tabs";
    version = "1.1.1";
    src = fetchFromGitHub {
      owner = "bulwarkmail";
      repo = "plugins";
      tag = "category-tabs@${finalAttrs.version}";
      hash = "sha256-+OpznBAU5Kc3NRuA18ByCzO4Iv90VrwNKCpjIcj1DYg=";
    };
    sourceRoot = "${finalAttrs.src.name}/category-tabs";
    npmDepsHash = "sha256-NI657FhvZHJguixQQirUYOb/uZnRvjbdm5XsgTrKZYk=";
    meta = {
      description = "Gmail-style inbox tabs (Primary / Social / Promotions / Updates) for Bulwark's message list";
      homepage = "https://extensions.bulwarkmail.org/extension/category-tabs";
      license = lib.licenses.agpl3Only;
      maintainers = with lib.maintainers; [ Cameo007 ];
    };
  });
  email-stats = mkBulwarkPlugin (finalAttrs: {
    pname = "bulwark-plugin-email-stats";
    version = "1.3.2";
    src = fetchFromGitHub {
      owner = "bulwarkmail";
      repo = "plugins";
      tag = "email-stats@${finalAttrs.version}";
      hash = "sha256-sGAXUTbIOxAFar3ZaTqLLQoD5fTQgCATkiBJgLqNqA4=";
    };
    sourceRoot = "${finalAttrs.src.name}/email-stats";
    npmDepsHash = "sha256-potm32NNWXjqkThg6b1WXcYlJd1OSLqv2fVOVCUXVDY=";
    meta = {
      description = "Sidebar section showing email activity statistics";
      homepage = "https://extensions.bulwarkmail.org/extension/email-stats";
      license = lib.licenses.agpl3Only;
      maintainers = with lib.maintainers; [ Cameo007 ];
    };
  });
  email-to-task = mkBulwarkPlugin (finalAttrs: {
    pname = "bulwark-plugin-email-to-task";
    version = "1.2.1";
    src = fetchFromGitHub {
      owner = "bulwarkmail";
      repo = "plugins";
      tag = "email-to-task@${finalAttrs.version}";
      hash = "sha256-oUZyOime4N2UJKXnLyosfu9B8doc5yjDQKXc3iA1lt4=";
    };
    sourceRoot = "${finalAttrs.src.name}/email-to-task";
    npmDepsHash = "sha256-zNffMU6p7zBo4EMezzT8H6HI1hJvGOyxwsBMBAQ2sm4=";
    meta = {
      description = "Turn a message into a task in Bulwark's own tasks, Vikunja, Todoist or a CalDAV task list, with a link back to the message and a due date taken from the text";
      homepage = "https://extensions.bulwarkmail.org/extension/email-to-task";
      license = lib.licenses.agpl3Only;
      maintainers = with lib.maintainers; [ Cameo007 ];
    };
  });
  external-link-warning = mkBulwarkPlugin (finalAttrs: {
    pname = "bulwark-plugin-external-link-warning";
    version = "2.0.0";
    src = fetchFromGitHub {
      owner = "bulwarkmail";
      repo = "plugins";
      tag = "external-link-warning@${finalAttrs.version}";
      hash = "sha256-9VAKo18R0lY7FB7iIUB1nmP+j6CDdKRAXkahhqbm0T4=";
    };
    sourceRoot = "${finalAttrs.src.name}/external-link-warning";
    npmDepsHash = "sha256-64OAipXBoSAo1kATUAsgGLSvk5go7DgIHXpqDTMKk4A=";
    meta = {
      description = "Warns before opening external links to unknown domains";
      homepage = "https://extensions.bulwarkmail.org/extension/external-link-warning";
      license = lib.licenses.agpl3Only;
      maintainers = with lib.maintainers; [ Cameo007 ];
    };
  });
  external-mail-warning = mkBulwarkPlugin (finalAttrs: {
    pname = "bulwark-plugin-external-mail-warning";
    version = "1.6.2";
    src = fetchFromGitHub {
      owner = "bulwarkmail";
      repo = "plugins";
      tag = "external-mail-warning@${finalAttrs.version}";
      hash = "sha256-8RkihUct6gH6/v35qX8KwZPqLHVQo7FHQdCmNJG4Ixk=";
    };
    sourceRoot = "${finalAttrs.src.name}/external-mail-warning";
    npmDepsHash = "sha256-V7i8WiGKWIAdY50pkt2nYEbGyW01IfvLRr4So58h1ZU=";
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
    version = "1.4.1";
    src = fetchFromGitHub {
      owner = "bulwarkmail";
      repo = "plugins";
      tag = "gravatar@${finalAttrs.version}";
      hash = "sha256-pjSOPp3qQXuDCb8Gd5MBGU6eRpB2C3WHJdKnNlNoEdw=";
    };
    sourceRoot = "${finalAttrs.src.name}/gravatar";
    npmDepsHash = "sha256-mBtjkDEjuCvmguevzBTFwZfCrevfaKsTYTaKIl9TDL8=";
    meta = {
      description = "Resolves Gravatar profile pictures for email contacts via the avatar transform hook";
      homepage = "https://extensions.bulwarkmail.org/extension/gravatar";
      license = lib.licenses.agpl3Only;
      maintainers = with lib.maintainers; [ Cameo007 ];
    };
  });
  impersonation-notice = mkBulwarkPlugin (finalAttrs: {
    pname = "bulwark-plugin-impersonation-notice";
    version = "1.4.2";
    src = fetchFromGitHub {
      owner = "bulwarkmail";
      repo = "plugins";
      tag = "impersonation-notice@${finalAttrs.version}";
      hash = "sha256-m1b8xKJdkL2kMes+WDFqF3cdIon5WFqI8+mmPi0qWKA=";
    };
    sourceRoot = "${finalAttrs.src.name}/impersonation-notice";
    npmDepsHash = "sha256-LqsyBxVcIbQFS8wUdEiOo3eRaCOwPqYnECi904vwazA=";
    meta = {
      description = "Shows a persistent top-of-app banner when the active session is a Stalwart master-user impersonation";
      homepage = "https://extensions.bulwarkmail.org/extension/impersonation-notice";
      license = lib.licenses.agpl3Only;
      maintainers = with lib.maintainers; [ Cameo007 ];
    };
  });
  jitsi-meet = mkBulwarkPlugin (finalAttrs: {
    pname = "bulwark-plugin-jitsi-meet";
    version = "1.3.1";
    src = fetchFromGitHub {
      owner = "bulwarkmail";
      repo = "plugins";
      tag = "jitsi-meet@${finalAttrs.version}";
      hash = "sha256-FWNVZGtLDaGGOFpVqJDByVPTwiZ0vzjK7B+WKFMBzNo=";
    };
    sourceRoot = "${finalAttrs.src.name}/jitsi-meet";
    npmDepsHash = "sha256-eHodP/I5+upO4e2a54Oa1JqHGxKsiB8nyToj8FQAHA0=";
    meta = {
      description = "Adds a 'Add Jitsi Meeting' button to calendar events";
      homepage = "https://extensions.bulwarkmail.org/extension/jitsi-meet";
      license = lib.licenses.agpl3Only;
      maintainers = with lib.maintainers; [ Cameo007 ];
    };
  });
  languagetool = mkBulwarkPlugin (finalAttrs: {
    pname = "bulwark-plugin-languagetool";
    version = "1.0.0";
    src = fetchFromGitHub {
      owner = "bulwarkmail";
      repo = "plugins";
      tag = "languagetool@${finalAttrs.version}";
      hash = "sha256-YjvGfyo5jVqT9nC9IHLJrxbWiUZfikSkc8imnB441mQ=";
    };
    sourceRoot = "${finalAttrs.src.name}/languagetool";
    npmDepsHash = "sha256-qwXFq6wEYbAtriVLQmk88jr7PGRDKM6+eJv1+N4nP/Q=";
    meta = {
      description = "Underlines spelling, grammar and style mistakes while you write, with suggestions to fix them";
      homepage = "https://extensions.bulwarkmail.org/extension/languagetool";
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
    version = "1.2.1";
    src = fetchFromGitHub {
      owner = "bulwarkmail";
      repo = "plugins";
      tag = "nextcloud@${finalAttrs.version}";
      hash = "sha256-3iyA4dkt7M6tx0jWpMpgkCIFo2LjPmNIr6HbkMETSG4=";
    };
    sourceRoot = "${finalAttrs.src.name}/nextcloud";
    npmDepsHash = "sha256-1aPJJOoq6fsp+LKngYyWMZ9nmqJ/fArh2WEBAyGWS7M=";
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
    version = "1.2.3";
    src = fetchFromGitHub {
      owner = "bulwarkmail";
      repo = "plugins";
      tag = "outlook-style-headers@${finalAttrs.version}";
      hash = "sha256-eb321loPWSON6rcsWbucOVzKj4YlpfIdCWlAFP7va80=";
    };
    sourceRoot = "${finalAttrs.src.name}/outlook-style-headers";
    npmDepsHash = "sha256-bQU0IlSq8D1JZ/1Zf+BwtqgAHPme5ZWdRBlRs+gTvSk=";
    meta = {
      description = "Replaces the default reply/forward quote header with an Outlook-style From / Sent / To / Cc / Subject block";
      homepage = "https://extensions.bulwarkmail.org/extension/outlook-style-headers";
      license = lib.licenses.agpl3Only;
      maintainers = with lib.maintainers; [ Cameo007 ];
    };
  });
  paperless = mkBulwarkPlugin (finalAttrs: {
    pname = "bulwark-plugin-paperless";
    version = "1.2.2";
    src = fetchFromGitHub {
      owner = "bulwarkmail";
      repo = "plugins";
      tag = "paperless@${finalAttrs.version}";
      hash = "sha256-2LDXyG/x2PBJOjq5Qljwhmc+JzI5IOhdplsB0/+2Hxc=";
    };
    sourceRoot = "${finalAttrs.src.name}/paperless";
    npmDepsHash = "sha256-DOCB2k+jRrRVxcFDd1ZD/b0Yt11CthFw7Lt7GGqwlqM=";
    meta = {
      description = "Send attachments and messages to Paperless-ngx, find your documents there and attach them to new mail";
      homepage = "https://extensions.bulwarkmail.org/extension/paperless";
      license = lib.licenses.agpl3Only;
      maintainers = with lib.maintainers; [ Cameo007 ];
    };
  });
  parcels = mkBulwarkPlugin (finalAttrs: {
    pname = "bulwark-plugin-parcels";
    version = "1.2.2";
    src = fetchFromGitHub {
      owner = "bulwarkmail";
      repo = "plugins";
      tag = "parcels@${finalAttrs.version}";
      hash = "sha256-0E6Ca83kmpaDsf0V2s+LLtVPnhvGNEKt38E73zgve5I=";
    };
    sourceRoot = "${finalAttrs.src.name}/parcels";
    npmDepsHash = "sha256-71KlxL2XFiNe7Xvc3cHDj1H8swsjYtqrM/u85AChp4w=";
    meta = {
      description = "Finds tracking numbers in your mail, shows where each parcel is and tells you when its status changes";
      homepage = "https://extensions.bulwarkmail.org/extension/parcels";
      license = lib.licenses.agpl3Only;
      maintainers = with lib.maintainers; [ Cameo007 ];
    };
  });
  pgp-true-end-to-end = mkBulwarkPlugin (finalAttrs: {
    pname = "bulwark-plugin-pgp-true-end-to-end";
    version = "2.0.2";
    src = fetchFromGitHub {
      owner = "paulhenry46";
      repo = "pgp-plugin";
      tag = finalAttrs.version;
      hash = "sha256-Ddh373plhyB791kTr8BmaI/XOrEv6nKjWgXBN7rspXk=";
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
    version = "1.3.3";
    src = fetchFromGitHub {
      owner = "bulwarkmail";
      repo = "plugins";
      tag = "quick-notes@${finalAttrs.version}";
      hash = "sha256-er97XE2yNmsFLzwaocA8pUMbsXWQBg/X0hxgZh6+dO8=";
    };
    sourceRoot = "${finalAttrs.src.name}/quick-notes";
    npmDepsHash = "sha256-d5CIHxFWZdhYNspXMUnjcPFapRIXiLYZmWxxGH4utys=";
    meta = {
      description = "Per-email sticky notes in the sidebar — jot notes while reading emails";
      homepage = "https://extensions.bulwarkmail.org/extension/quick-notes";
      license = lib.licenses.agpl3Only;
      maintainers = with lib.maintainers; [ Cameo007 ];
    };
  });
  reply-all-guardrail = mkBulwarkPlugin (finalAttrs: {
    pname = "bulwark-plugin-reply-all-guardrail";
    version = "1.3.2";
    src = fetchFromGitHub {
      owner = "bulwarkmail";
      repo = "plugins";
      tag = "reply-all-guardrail@${finalAttrs.version}";
      hash = "sha256-YQmXepTYBmXyYR2HZAtaadqR8FntzCk3eH8fn9VvNT8=";
    };
    sourceRoot = "${finalAttrs.src.name}/reply-all-guardrail";
    npmDepsHash = "sha256-LqYIkut/yfJ+p+L8F99iidbFtH/q3cVSJOBqrTw+oj8=";
    meta = {
      description = "Asks for confirmation before reply-all (and optionally before any send) when the recipient count crosses a threshold";
      homepage = "https://extensions.bulwarkmail.org/extension/reply-all-guardrail";
      license = lib.licenses.agpl3Only;
      maintainers = with lib.maintainers; [ Cameo007 ];
    };
  });
  send-checks = mkBulwarkPlugin (finalAttrs: {
    pname = "bulwark-plugin-send-checks";
    version = "1.0.0";
    src = fetchFromGitHub {
      owner = "bulwarkmail";
      repo = "plugins";
      tag = "send-checks@${finalAttrs.version}";
      hash = "sha256-9VAKo18R0lY7FB7iIUB1nmP+j6CDdKRAXkahhqbm0T4=";
    };
    sourceRoot = "${finalAttrs.src.name}/send-checks";
    npmDepsHash = "sha256-u5HXcR5O+DfcEqOHojA58qc4OgXXMB0culHvMifiRd4=";
    meta = {
      description = "Checks a message before it is sent: IBANs, payment card numbers, keywords and your own patterns in the subject, text and text attachments, and attachment types and sizes";
      homepage = "https://extensions.bulwarkmail.org/extension/send-checks";
      license = lib.licenses.agpl3Only;
      maintainers = with lib.maintainers; [ Cameo007 ];
    };
  });
  smime = mkBulwarkPlugin (finalAttrs: {
    pname = "bulwark-plugin-smime";
    version = "1.4.3";
    src = fetchFromGitHub {
      owner = "bulwarkmail";
      repo = "plugins";
      tag = "smime@${finalAttrs.version}";
      hash = "sha256-9VAKo18R0lY7FB7iIUB1nmP+j6CDdKRAXkahhqbm0T4=";
    };
    sourceRoot = "${finalAttrs.src.name}/smime";
    npmDepsHash = "sha256-P5af9HCUTrzr6NdugZalwSlP2+Niih8JuI9KHddlf4A=";
    meta = {
      description = "End-to-end S/MIME for webmail";
      homepage = "https://extensions.bulwarkmail.org/extension/smime";
      license = lib.licenses.agpl3Only;
      maintainers = with lib.maintainers; [ Cameo007 ];
    };
  });
  spam-score = mkBulwarkPlugin (finalAttrs: {
    pname = "bulwark-plugin-spam-score";
    version = "1.1.2";
    src = fetchFromGitHub {
      owner = "bulwarkmail";
      repo = "plugins";
      tag = "spam-score@${finalAttrs.version}";
      hash = "sha256-Kj6v2p9lWTlWxFQi+54EOhCEyg/dbIlAU4mNwvfufYs=";
    };
    sourceRoot = "${finalAttrs.src.name}/spam-score";
    npmDepsHash = "sha256-h42I+It0CUDo1btAIOjPpPS0BPQAXxf5m/g7hRv2Mik=";
    meta = {
      description = "Adds a Spam Analysis section to a message's \"More details\" panel";
      homepage = "https://extensions.bulwarkmail.org/extension/spam-score";
      license = lib.licenses.agpl3Only;
      maintainers = with lib.maintainers; [ Cameo007 ];
    };
  });
  team-inbox = mkBulwarkPlugin (finalAttrs: {
    pname = "bulwark-plugin-team-inbox";
    version = "1.0.1";
    src = fetchFromGitHub {
      owner = "bulwarkmail";
      repo = "plugins";
      tag = "team-inbox@${finalAttrs.version}";
      hash = "sha256-6em/+nzUnAYSi/me82gBdEZ2OP8rnxLmJi31GtaZ370=";
    };
    sourceRoot = "${finalAttrs.src.name}/team-inbox";
    npmDepsHash = "sha256-RmIt3dmoDk9MiYoZgdAln2C07r/AZgpGJniIUDPAbXA=";
    meta = {
      description = "Assign messages in a team mailbox (a Stalwart group account) to a member and mark them done";
      homepage = "https://extensions.bulwarkmail.org/extension/team-inbox";
      license = lib.licenses.agpl3Only;
      maintainers = with lib.maintainers; [ Cameo007 ];
    };
  });
  timezones = mkBulwarkPlugin (finalAttrs: {
    pname = "bulwark-plugin-timezones";
    version = "1.1.2";
    src = fetchFromGitHub {
      owner = "bulwarkmail";
      repo = "plugins";
      tag = "timezones@${finalAttrs.version}";
      hash = "sha256-UAH620cO2xpVO9CI12fwx/FoQcn2d2IQLr8RfaQNaeg=";
    };
    sourceRoot = "${finalAttrs.src.name}/timezones";
    npmDepsHash = "sha256-ZDj5pF76iJoJXClvXZ9kcnfD7QV8SYPcl5p1zb7r4Ok=";
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
