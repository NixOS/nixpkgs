
cargoAuditHook() {
    echo "Executing cargoAuditHook"

    local find_args=(
      # Find all executable files
      "-type" "f" "-executable"
      # Run cargo-audit
      "-exec" "cargo" "audit"
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
      "bin" "{}"
      "+"
    )

    local -a dirsArray
    concatTo dirsArray "$(getAllOutputNames)"

    # Even though we ignore yanked, it still complains, so we must redirect stderr
    local json
    json="$(find "${dirsArray[@]}" "${find_args[@]}" 2> /dev/null)"
    nixDebugLog "$(echo "$json" | jq)"

    # Collect whether vulnerabilities were found or not
    local auditStatus=$(echo "$json" | jq --exit-status '.vulnerabilities.found')

    if [[ -n "@failOnAuditFail@" ]] && "$auditStatus"; then
      # Pretty-print the JSON
      echo "$json" | jq

      # Exit
      exit 1
    fi

    echo "Finished cargoAuditHook"
}

postInstall+=cargoAuditHook
