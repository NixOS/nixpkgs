postInstallHooks+=('licenseComplianceHook')

licenseComplianceHook () {
  # Ensure NIX_ATTRS_JSON_FILE exists
  if [ -z $NIX_ATTRS_JSON_FILE ]; then
    echo "license-compliance-hook: NIX_ATTRS_JSON_FILE not set, is __structuredAttrs set to true?" >&2
    exit 1
  fi
  if [ ! -f $NIX_ATTRS_JSON_FILE ]; then
    echo "license-compliance-hook: NIX_ATTRS_JSON_FILE not found" >&2
    exit 1
  fi

  # Ensure that includeLicenses is set to an attribute set or list in NIX_ATTRS_JSON_FILE
  includeLicenses=$(@jq@ -r '.includeLicenses' $NIX_ATTRS_JSON_FILE)
  if [ "$includeLicenses" = "null" ]; then
    echo "license-compliance-hook: includeLicenses not set in derivation" >&2
    exit 1
  fi
  if [ $(@jq@ -r 'type' <<< $includeLicenses) != "object" ]; then
    echo "license-compliance-hook: includeLicenses wrong type in derivation (expected AttrSet)" >&2
    exit 1
  fi

  # Make license directory
  mkdir -p $out/share/doc/licenses

  ls -la .

  # Iterate over includeLicenses keys
  for license in $(@jq@ -r '.includeLicenses | keys[]' $NIX_ATTRS_JSON_FILE); do
    licenseData=$(@jq@ ".includeLicenses[\"$license\"]" $NIX_ATTRS_JSON_FILE)
    # If we're a string, look for a file
    if @jq@ -r 'type' <<< $licenseData | grep -q string; then
      echo "DEBUG 2: $license"
      licenseFile=$(@jq@ -r ".includeLicenses[\"$license\"]" $NIX_ATTRS_JSON_FILE)
      # Check that the file exists
      if [ ! -f $licenseFile ]; then
        echo "license-compliance-hook: $licenseFile not found" >&2
        exit 1
      fi
      # Check that the license is not already in the licenses directory
      if [ -f $out/share/doc/licenses/$license ]; then
        echo "license-compliance-hook: $license already exists in licenses directory" >&2
        exit 1
      fi
      # Copy the license
      cp $licenseFile $out/share/doc/licenses/$license
    fi
    # If we're an object, look for spdxId
    if @jq@ -r 'type' <<< $licenseData | grep -q object; then
      spdxId=$(@jq@ -r '.spdxId' <<< $licenseData)
      if [ $spdxId == "null" ]; then
        echo "license-compliance-hook: spdxId not set for $license" >&2
        exit 1
      fi
      # Check that the license is in common-licenses
      if [ ! -f @common-licenses@/$spdxId ]; then
        echo "license-compliance-hook: $spdxId not found in common-licenses" >&2
        exit 1
      fi
      # Check that the license is not already in the licenses directory
      if [ -f $out/share/doc/licenses/$license ]; then
        echo "license-compliance-hook: $license already exists in licenses directory" >&2
        exit 1
      fi
      # Symlink the license
      ln -s @common-licenses@/$spdxId $out/share/doc/licenses/$license
    fi
  done
}
