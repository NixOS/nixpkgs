{ pkgs ? import <nixpkgs> {}, ... }:

{
  # ── Dummy provider tests ──────────────────────────────────────────
  dummy-basic = pkgs.callPackage ./dummy-basic.nix { };
  dummy-permissions = pkgs.callPackage ./dummy-permissions.nix { };
  dummy-ordering = pkgs.callPackage ./dummy-ordering.nix { };
  dummy-custom-path = pkgs.callPackage ./dummy-custom-path.nix { };
  dummy-multiple-secrets = pkgs.callPackage ./dummy-multiple-secrets.nix { };
  dummy-idempotency = pkgs.callPackage ./dummy-idempotency.nix { };

  # ── systemd-creds provider tests ──────────────────────────────────
  systemd-creds-basic = pkgs.callPackage ./systemd-creds-basic.nix { };

  # ── Evaluation-time assertion tests ───────────────────────────────
  store-leak-rejected = pkgs.callPackage ./store-leak-rejected.nix { };
  source-required = pkgs.callPackage ./source-required.nix { };
}
