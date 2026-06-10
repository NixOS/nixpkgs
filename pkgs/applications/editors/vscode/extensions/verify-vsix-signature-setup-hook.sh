# Verify VSIX signature using VS Code's bundled vsce-sign binary.
# Thin wrapper around verify-vsix-signature.sh (the shared verifier) that runs
# in preUnpackHooks, before the VSIX is unpacked. At that point $src points to
# the downloaded VSIX, i.e. the exact bytes Microsoft signed.
#
# Opt-in: this hook is only attached when `verifySignature` is enabled (per
# extension, or globally via nixpkgs config `vscodeExtensions.verifySignature`)
# and vsce-sign is available (see vscode-utils.nix), so the default build stays
# free and buildable on Hydra / with vscodium.

_verifyVsixSignaturePreUnpack() {
    # Defensive: the hook is only attached when both are set, but guard anyway.
    if [[ -z "${signatureArchive:-}" || -z "${src:-}" ]]; then
        echo "WARNING: missing \$src or \$signatureArchive, skipping signature verification" >&2
        return 0
    fi

    @verifyScript@ "@vsceSign@" "$src" "$signatureArchive"
}

# Run signature verification before unpacking
preUnpackHooks+=(_verifyVsixSignaturePreUnpack)
