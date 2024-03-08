{ common-updater-scripts, curl, fetchFromGitHub, jq, lib, php, writeShellScript }:

php.buildComposerProject (finalAttrs: {
  pname = "platformsh";
  version = "4.11.4";

  src = fetchFromGitHub {
    owner = "platformsh";
    repo = "legacy-cli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-4Fo4vmTEo0rSJNtoGz/mRv5dRCMq5vJmnwAxsvfs9qo=";
  };

  vendorHash = "sha256-MuZKa4lKvfls85cYjOTHHd6lKVVS0QJD6Pdn7csSzUo=";

  prePatch = ''
    substituteInPlace config-defaults.yaml \
      --replace "@version-placeholder@" "${finalAttrs.version}"
  '';

  passthru.updateScript = writeShellScript "update-${finalAttrs.pname}" ''
    set -o errexit
    export PATH="${lib.makeBinPath [ curl jq common-updater-scripts ]}"
    NEW_VERSION=$(curl -s https://api.github.com/repos/platformsh/legacy-cli/releases/latest | jq .tag_name --raw-output)

    if [[ "v${finalAttrs.version}" = "$NEW_VERSION" ]]; then
      echo "The new version same as the old version."
      exit 0
    fi

    update-source-version "platformsh" "$NEW_VERSION"
  '';

  meta = {
    description = "The unified tool for managing your Platform.sh services from the command line.";
    homepage = "https://github.com/platformsh/legacy-cli";
    license = lib.licenses.mit;
    mainProgram = "platform";
    maintainers = with lib.maintainers; [ shyim ];
    platforms = lib.platforms.all;
  };
})
