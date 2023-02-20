{ stdenv
, lib
, buildGoModule
, fetchFromGitHub
, rsync
, openssh
, writeShellScript
, unstableGitUpdater
, _experimental-update-script-combinators
}:

buildGoModule rec {
  pname = "gokrazy-rsync";
  version = "unstable-2022-10-17";

  src = fetchFromGitHub {
    owner = "gokrazy";
    repo = "rsync";
    rev = "197246cdaa697ce55d511dd99491a2cc1465ef18";
    sha256 = "sha256-u7Z9eXpq1pvi46nkfbaZzXXkKvR8DCOeqdop0p3HYgw=";
  };

  vendorHash = "sha256-NIiTVJfAU8L9wZB7TeiVzDjkI6d7SGFiLr36kWdHtlw=";

  nativeCheckInputs = [
    rsync
    openssh
  ];

  postPatch = lib.optionalString stdenv.hostPlatform.isMinGW ''
    # Depends on Unix functions
    rm -r internal/rsynctest
  '';

  passthru = {
    updateScript =
      let
        updateSource = unstableGitUpdater { };
        updateVendor = writeShellScript "update-gokrazy-rsync-vendor-hash" ''
          set -euo pipefail
          FILE="$(nix-instantiate --eval -E 'with import ./. {}; (builtins.unsafeGetAttrPos "version" gokrazy-rsync).file' | tr -d '"')"
          replaceHash() {
            old="''${1?old hash missing}"
            new="''${2?new hash missing}"
            awk -v OLD="$old" -v NEW="$new" '{
              if (i=index($0, OLD)) {
                $0 = substr($0, 1, i-1) NEW substr($0, i+length(OLD));
              }
              print $0;
            }' "$FILE" | sponge "$FILE"
          }
          extractVendorHash() {
            original="''${1?original hash missing}"
            result="$(nix-build -A gokrazy-rsync.go-modules 2>&1 | tail -n3 | grep 'got:' | cut -d: -f2- | xargs echo || true)"
            [ -z "$result" ] && { echo "$original"; } || { echo "$result"; }
          }

          goHash="$(nix-instantiate --eval -A gokrazy-rsync.vendorHash | tr -d '"')"
            emptyHash="$(nix-instantiate --eval -A lib.fakeHash | tr -d '"')"
            replaceHash "$goHash" "$emptyHash"
            replaceHash "$emptyHash" "$(extractVendorHash "$goHash")"
        '';
      in
        _experimental-update-script-combinators.sequence [
          updateSource
          updateVendor
        ];
  };

  meta = {
    description = "Back-end for Vikunja to-do list app";
    homepage = "https://github.com/gokrazy/rsync";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ jtojnar ];
    platforms = lib.platforms.all;
  };
}
