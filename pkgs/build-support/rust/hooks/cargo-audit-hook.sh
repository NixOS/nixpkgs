
cargoAuditHook() {
    echo "Executing cargoAuditHook"

    local -a dirsArray
    concatTo dirsArray "$(getAllOutputNames)"

    # Get all the files created with cargo-auditable
    local -a auditableFiles
    mapfile -d $'\0' auditableFiles < <(grep --null -rl "AUDITABLE_VERSION_INFO" "${dirsArray[@]}" )
    nixDebugLog "cargo-auditable files:"
    nixDebugLog "${auditableFiles[*]}"

    local auditArgs=(
      # If someone has an old checkout don't complain
      "--stale"
      # Don't try to fetch an updated database
      "--no-fetch"
      # Only look at the OS and CPU arch we are building for
      "--target-os" "@os@"
      "--target-arch" "@arch@"
      # Use the Nixpkgs database
      "--db" "@auditDatabase@"
      # Ignore yanked because we cannot look that up in the sandbox
      "--ignore" "yanked"
      "bin"
    )

    if (( ${#auditableFiles[@]} == 0 )); then
      # If there's nothing to audit, don't do anything.
      return
    fi

    local json human
    # Only audit one executable per cargo lock file since cargo-audit doesn't know what was used
    # where
    json="$(cargo audit --json "${auditArgs[@]}" "${auditableFiles[0]}" 2> /dev/null || true)"
    human="$(cargo audit "${auditArgs[@]}" "${auditableFiles[0]}" 2> /dev/null || true)"

    echo "cargo-audit report of $pname"
    echo "note that there may be false-positives."
    nixDebugLog "$(echo "$json" | jq -c)"
    echo "$human"

    echo "Finished cargoAuditHook"
}

if [[ ! -v runCargoAudit ]]; then
  postFixupHooks+=(cargoAuditHook)
fi
