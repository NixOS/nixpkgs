{
  cfg,
  config,
  lib,
  pkgs,
}:

let
  pihole = cfg.piholePackage;
  makePayload =
    list:
    builtins.toJSON {
      inherit (list) type enabled;
      address = list.url;
      comment = list.description;
    };
  payloads = map makePayload cfg.lists;
in
''
  # Can't use -u (unset) because api.sh uses API_URL before it is set
  set -eo pipefail
  pihole="${lib.getExe pihole}"
  jq="${lib.getExe pkgs.jq}"

  # If the database doesn't exist, it needs to be created with gravity.sh
  if [ ! -f '${cfg.stateDirectory}'/gravity.db ]; then
    $pihole -g
    # Send SIGRTMIN to FTL, which makes it reload the database, opening the newly created one
    ${lib.getExe' pkgs.procps "kill"} -s SIGRTMIN $(systemctl show --property MainPID --value ${config.systemd.services.pihole-ftl.name})
  fi

  source ${pihole}/share/pihole/advanced/Scripts/api.sh
  source ${pihole}/share/pihole/advanced/Scripts/utils.sh

  any_failed=0

  addList() {
    local payload="$1"

    echo "Adding list: $payload"
    local result=$(PostFTLData "lists" "$payload")

    local error="$($jq '.error' <<< "$result")"
    if [[ "$error" != "null" ]]; then
        echo "Error: $error"
        any_failed=1
        return
    fi

    id="$($jq '.lists.[].id?' <<< "$result")"
    if [[ "$id" == "null" ]]; then
        any_failed=1
        error="$($jq '.processed.errors.[].error' <<< "$result")"
        echo "Error: $error"
        return
    fi

    echo "Added list ID $id: $result"
  }

  for i in 1 2 3; do
    (TestAPIAvailability) && break
    echo "Retrying API shortly..."
    ${lib.getExe' pkgs.coreutils "sleep"} .5s
  done;

  LoginAPI

  ${builtins.concatStringsSep "\n" (
    map (
      payload:
      lib.pipe payload [
        lib.strings.escapeShellArg
        (payload: "addList ${payload}")
      ]
    ) payloads
  )}

  # Run gravity.sh to load any new lists
  $pihole -g
  exit $any_failed
''
