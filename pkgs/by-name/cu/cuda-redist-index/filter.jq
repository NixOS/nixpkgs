walk(
  # If we have reached an object with a `sha256` key, we need to augment the object with
  # the feature and nar hash.
  if type == "object" and has("sha256") then
    # Get the hash of the object.
    .sha256 as $sha256 |
    # Get the unpacked store path, which we use to get the feature and nar hash.
    $hashToUnpackedStorePath[0][$sha256] as $unpackedStorePath |
    $unpackedStorePathToFeature[0][$unpackedStorePath] as $feature |
    $unpackedStorePathToNarHash[0][$unpackedStorePath] as $narHash |
    # Update the object with the feature and nar hash.
    . + {
      feature: $feature,
      narHash: $narHash,
    }
  else
    # Otherwise, just return the value.
    .
  end
) |
# Remove any null values.
del(.. | nulls)
