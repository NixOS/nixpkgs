{ runCommand, changelog-d }:

runCommand "changelog-d-basic-test"
  {
    nativeBuildInputs = [ changelog-d ];
  }
  ''
    mkdir changelogs
    cat > changelogs/config <<EOF
    organization: NixOS
    repository: boondoggle
    EOF
    cat > changelogs/a <<EOF
    synopsis: Support numbers with incrementing base-10 digits
    issues: #1234
    description: {
    This didn't work before.
    }
    EOF
    changelog-d changelogs >$out
    cat -n $out
    echo Checking the generated output
    set -x
    grep -F 'Support numbers with incrementing base-10 digits' $out >/dev/null
    grep -F 'https://github.com/NixOS/boondoggle/issues/1234' $out >/dev/null
    set +x
  ''
