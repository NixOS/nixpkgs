# Verify VSIX signature using VS Code's bundled vsce-sign binary
# This hook runs at the start of unpackPhase before sources are processed.
# At this point, $src points to the main source (the VSIX file).

_verifyVsixSignaturePreUnpack() {
    # Only verify if signatureArchive is provided
    if [[ -z "${signatureArchive:-}" ]]; then
        return 0
    fi

    # Opt-out: user has explicitly accepted that verification may not run here.
    # Covers environments where vsce-sign is absent (custom VS Code variants) or
    # can't access the OS trust store (Darwin strict sandbox, where keychain
    # reads are blocked and vsce-sign would otherwise fail with exit code 36).
    if [[ "${allowMissingVsceSign:-}" == "1" || "${allowMissingVsceSign:-}" == "true" ]]; then
        echo "WARNING: signature verification SKIPPED (allowMissingVsceSign=true)" >&2
        return 0
    fi

    # $src should be the VSIX file path
    if [[ -z "${src:-}" ]]; then
        echo "WARNING: \$src is not set, cannot verify signature" >&2
        return 0
    fi

    local vsceSign="@vsceSign@"

    if [[ ! -x "$vsceSign" ]]; then
        echo "ERROR: vsce-sign not found at $vsceSign" >&2
        echo "       Signature verification was requested (signatureArchive is set) but the verifier is unavailable." >&2
        echo "       Set allowMissingVsceSign = true on the extension to skip verification with a warning." >&2
        return 1
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
