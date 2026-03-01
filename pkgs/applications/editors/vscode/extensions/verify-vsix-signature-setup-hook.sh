# Verify VSIX signature using VS Code's bundled vsce-sign binary
# This hook runs at the start of unpackPhase before sources are processed.
# At this point, $src points to the main source (the VSIX file).

_verifyVsixSignaturePreUnpack() {
    # Only verify if signatureArchive is provided
    if [[ -z "${signatureArchive:-}" ]]; then
        return 0
    fi

    # $src should be the VSIX file path
    if [[ -z "${src:-}" ]]; then
        echo "WARNING: \$src is not set, cannot verify signature" >&2
        return 0
    fi

    local vsceSign="@vscode@/lib/vscode/resources/app/node_modules/@vscode/vsce-sign/bin/vsce-sign"

    if [[ ! -x "$vsceSign" ]]; then
        echo "WARNING: vsce-sign not found at $vsceSign - signature verification skipped" >&2
        return 0
    fi

    echo "Verifying VSIX signature..."
    local exitCode=0
    "$vsceSign" verify --package "$src" --signaturearchive "$signatureArchive" || exitCode=$?

    if [[ $exitCode -eq 0 ]]; then
        echo "Signature verification: PASSED"
        return 0
    fi

    echo "Signature verification: FAILED (exit code: $exitCode)" >&2
    case $exitCode in
        30) echo "ERROR: Package integrity check failed - contents don't match signature" >&2 ;;
        31) echo "ERROR: Invalid signature format" >&2 ;;
        35) echo "ERROR: Package has been tampered with" >&2 ;;
        36) echo "ERROR: Certificate is not trusted" >&2 ;;
        37) echo "ERROR: Certificate has been revoked" >&2 ;;
        *)  echo "ERROR: Unknown verification error" >&2 ;;
    esac
    return 1
}

# Run signature verification before unpacking
preUnpackHooks+=(_verifyVsixSignaturePreUnpack)
