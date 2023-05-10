{ lib, runCommand }:

# Reference: https://eclecticlight.co/2022/09/17/how-to-check-an-apps-signature

{ package
, path

# Whether to require the app to be notarized
, requireNotarization ? false

# The Team ID to expect
, teamId ? null
}:

runCommand "${package.name}-test-codesign" {
  # Unfortunately, we do depend on the system codesign and spctl
  __noChroot = true;

  meta.platforms = lib.platforms.darwin;
} (''
  mkdir -p $out
  path="${package}/${path}"

  echo "checking that $path is signed..."
  /usr/bin/codesign -dvvv --requirements - $path 2>&1 | tee $out/codesign.out
  echo
'' + lib.optionalString requireNotarization ''
  echo "checking that $path is notarized..."
  /usr/sbin/spctl -a -vv $path 2>&1 | tee $out/spctl.out
  echo
'' + lib.optionalString (teamId != null) ''
  echo "checking that $path is signed with the correct Team ID..."
  teamId=$(grep -E '^TeamIdentifier=' $out/codesign.out | cut -d'=' -f2)
  if [[ "$teamId" != "${teamId}" ]]; then
    echo "ERROR: expected ${teamId}, got $teamId"
    exit 1
  fi
'')
