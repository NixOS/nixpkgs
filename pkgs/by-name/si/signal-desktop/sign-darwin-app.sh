# shellcheck shell=bash

signSignalDarwinApp() {
  # Hardened runtime library validation rejects the Electron framework when
  # the app or helpers lack a matching signing team ID. Keep Signal's other
  # entitlements and allow library loading in both ad-hoc signing scopes.
  python3 - <<'PY'
import plistlib
from pathlib import Path

for name in ("entitlements.mac.plist", "entitlements.mac.inherit.plist"):
    source = Path("build", name).read_bytes()
    entitlements = plistlib.loads(source[source.index(b"<?xml"):])
    entitlements["com.apple.security.cs.disable-library-validation"] = True
    Path(name).write_bytes(plistlib.dumps(entitlements))
PY

  local bundle="${out:?}/Applications/Signal.app"
  local helper scope
  local -a helperArgs=()
  for helper in "${bundle}/Contents/Frameworks/Signal Helper"*.app; do
    [[ -d "${helper}" ]] || continue
    scope="${helper#"${bundle}/"}"
    helperArgs+=(
      --code-signature-flags "${scope}:runtime"
      --entitlements-xml-file "${scope}:entitlements.mac.inherit.plist"
    )
  done
  if ((${#helperArgs[@]} == 0)); then
    echo "No Signal helper bundles found in ${bundle}" >&2
    return 1
  fi

  rcodesign sign --config-file /dev/null --code-signature-flags runtime \
    --entitlements-xml-file entitlements.mac.plist "${helperArgs[@]}" "${bundle}"
}

postFixupHooks+=(signSignalDarwinApp)
