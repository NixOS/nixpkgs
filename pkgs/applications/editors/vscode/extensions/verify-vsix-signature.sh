#!/usr/bin/env bash
# Verify a VSIX package's VS Code Marketplace signature using Microsoft's
# vsce-sign binary.
#
# Single source of truth for signature verification, shared between the
# build-time setup hook (verify-vsix-signature-setup-hook.sh) and the update
# script (vscode_extension_update.py), so both honour the same verifier and
# exit-code semantics. Takes everything as arguments so it has no build-time
# or Nix dependencies and can be invoked directly (e.g. `bash this.sh ...`).
#
# Usage: verify-vsix-signature.sh <vsce-sign> <vsix> <signature-archive>
set -uo pipefail

vsceSign="${1:?vsce-sign path required}"
vsix="${2:?vsix path required}"
signatureArchive="${3:?signature archive path required}"

if [[ ! -x "$vsceSign" ]]; then
    echo "ERROR: vsce-sign not found at $vsceSign" >&2
    exit 1
fi

echo "Verifying VSIX signature..."
exitCode=0
"$vsceSign" verify --package "$vsix" --signaturearchive "$signatureArchive" || exitCode=$?

if [[ $exitCode -eq 0 ]]; then
    echo "Signature verification: PASSED"
    exit 0
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
exit "$exitCode"
