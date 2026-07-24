{ lib, curl-impersonate }:

# nixpkgs-update: no auto update
curl-impersonate.override {
  c-aresSupport = true;
}
// {
  meta = lib.removeAttrs (curl-impersonate.meta or { }) [ "position" ];
}
