
cargoAuditHook() {
    echo "Executing cargoAuditHook"

    local -a dirsArray
    concatTo dirsArray "$(getAllOutputNames)"

    # Get all the files created with cargo-auditable
    local -a auditableFiles
    mapfile -d $'\0' auditableFiles < <(grep --null -rl "AUDITABLE_VERSION_INFO" "${dirsArray[@]}" )
    nixDebugLog "cargo-auditable files:"
    nixDebugLog "$(echo "$auditableFiles")"

    local auditArgs=(
      # If someone has an old checkout don't complain
      "--stale"
      # Don't try to fetch an updated database
      "--no-fetch"
      # Output a json report
      "--json"
      # Only look at the OS and CPU arch we are building for
      "--target-os" "@os@"
      "--target-arch" "@arch@"
      # Use the Nixpkgs database
      "--db" "@auditDatabase@"
      # Ignore yanked because we cannot look that up in the sandbox
      "--ignore" "yanked"
      "bin"
    )

    # Even though we ignore yanked, it still complains, so we must redirect stderr
    local json
    json="$(cargo audit "${auditArgs[@]}" "${auditableFiles[@]}" 2> /dev/null)"
    nixDebugLog "cargo-audit output:"
    nixDebugLog "$(echo "$json" | jq)"

    # Collect whether vulnerabilities were found or not
    local auditStatus=$(echo "$json" | jq --exit-status '.vulnerabilities.found')

    if "$auditStatus"; then
      # Pretty-print the JSON
      echo "$json" | jq

      if [[ -n "@failOnAuditFail@" ]]; then
        # Exit
        exit 1
      fi
    fi

    echo "Finished cargoAuditHook"
}

if [[ ! -v runCargoAudit ]]; then
  postInstall+=(cargoAuditHook)
fi
