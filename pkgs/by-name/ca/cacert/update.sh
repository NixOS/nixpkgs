#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix common-updater-scripts jq

# Build both the cacert package and an overridden version where we use the source attribute of NSS.
# Cacert and NSS are both from the same upstream sources. They are decoupled as
# the cacert output only cares about a few infrequently changing files in the
# sources while the NSS source code changes frequently.
#
# By having cacert on a older source revision that produces the same
# certificate output as a newer version we can avoid large amounts of
# unnecessary rebuilds.
#
# As of this writing there are a few magnitudes more packages depending on
# cacert than on nss.
#
# We use `nss_latest` instead of `nss_esr`, because that is the newer version
# and we want up-to-date certificates.
# `nss_esr` is used for the ecosystem at large through the `nss` attribute,
# because it is updated less frequently and maintained for longer, whereas `nss_latest`
# is used for software that actually needs a new nss, e.g. Firefox.

set -ex

BASEDIR="$(dirname "$0")/../../../.."


CURRENT_PATH=$(nix-build --no-out-link -A cacert.out)
PATCHED_PATH=$(nix-build --no-out-link -E "with import $BASEDIR {}; (cacert.override { nssOverride = nss_latest; }).out")

# Check the hash of the etc subfolder
# We can't check the entire output as that contains the nix-support folder
# which contains the output path itself.
CURRENT_HASH=$(nix-hash "$CURRENT_PATH/etc")
PATCHED_HASH=$(nix-hash "$PATCHED_PATH/etc")

if [[ "$CURRENT_HASH" !=  "$PATCHED_HASH" ]]; then
    NSS_VERSION=$(nix-instantiate --json --eval -E "with import $BASEDIR {}; nss_latest.version" | jq -r .)
    update-source-version --version-key=srcVersion cacert.src "$NSS_VERSION"
fi
