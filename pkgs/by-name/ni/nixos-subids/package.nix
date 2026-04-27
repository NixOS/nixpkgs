{
  lib,
  rustPlatform,
  nixosTests,
}:

rustPlatform.buildRustPackage {
  __structuredAttrs = true;

  pname = "nixos-subids";
  version = "0.1.0";

  src = lib.sourceFilesBySuffices ./. [
    ".rs"
    ".toml"
    ".lock"
  ];

  cargoLock.lockFile = ./Cargo.lock;

  stripAllList = [ "bin" ];

  passthru.tests = {
    inherit (nixosTests) nixos-subids;
  };

  meta = {
    description = "Manage /etc/subuid and /etc/subgid for NixOS";
    longDescription = ''
      Maintains /etc/subuid and /etc/subgid from the declarative
      users.users.<name>.{autoSubUidGidRange,subUidRanges,subGidRanges}
      options when user management is handled by userborn or
      systemd-sysusers, replacing the corresponding logic in
      update-users-groups.pl.

      Existing entries are never removed so that subordinate id ranges
      cannot be reassigned to a different owner across generations.
    '';
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ rvdp ];
    mainProgram = "nixos-subids";
  };
}
