# Shared fixtures for the GitLab Enterprise Edition license tests
# (ee.nix and ee-activation.nix).
#
# The core trick: GitLab validates a license by RSA-decrypting it with a public
# key. We generate a throwaway keypair at build time, sign a license blob with
# gitlab's own gitlab-license gem, and override Gitlab::License.encryption_key with
# the public half so GitLab accepts the blob exactly as it would a real license.
# This lets the tests prove a license ends up in the database without any real
# GitLab-issued credentials.

{ pkgs, lib }:

let
  licenseGen = pkgs.writeText "gen-license.rb" ''
    require "gitlab/license"
    Gitlab::License.encryption_key = OpenSSL::PKey::RSA.new(File.read(ARGV[0]))
    license = Gitlab::License.new
    license.licensee = {
      "Name" => "NixOS Test",
      "Company" => "NixOS",
      "Email" => "test@example.com",
    }
    license.starts_at = Date.today - 1
    license.expires_at = Date.today + 365
    license.cloud_licensing_enabled = true
    license.restrictions = { plan: "ultimate", active_user_count: 100 }
    print license.export
  '';

  # An RSA keypair plus a license blob signed by it. gitlab-license is
  # edition-independent, so the (free) CE rubyEnv generates the blob, keeping the
  # fixture out of the unfree gitlab-ee closure.
  licenseFixture =
    pkgs.runCommand "gitlab-test-license"
      {
        nativeBuildInputs = [
          pkgs.gitlab.rubyEnv.wrappedRuby
          pkgs.openssl
        ];
      }
      ''
        mkdir -p $out
        openssl genrsa -out key.pem 2048 2>/dev/null
        openssl rsa -in key.pem -pubout -out $out/key.pub.pem 2>/dev/null
        ruby ${licenseGen} key.pem > $out/license-blob
      '';
in
{
  inherit licenseFixture;

  # Initializer that makes GitLab trust our test keypair instead of the
  # GitLab-issued production key.
  encryptionKeyOverride = ''
    Gitlab::License.encryption_key = OpenSSL::PKey::RSA.new(File.read("${licenseFixture}/key.pub.pem"))
  '';

  # GitLab's HTTP client blocks requests to loopback/private addresses (SSRF
  # protection), which would stop a cloud-activation request from reaching an
  # in-VM mock portal. This is the initializer equivalent of the admin setting
  # "Allow requests to the local network from webhooks and services", applied from
  # boot so it is in effect when gitlab-db-config runs the activation.
  allowLocalRequestsOverride = ''
    module Gitlab
      module CurrentSettings
        def self.allow_local_requests_from_web_hooks_and_services?
          true
        end
      end
    end
  '';

  # Base gitlab settings shared by both tests. Values are test fixtures only.
  commonGitlab = {
    enable = true;
    databasePasswordFile = pkgs.writeText "dbPassword" "xo0daiF4";
    initialRootPasswordFile = pkgs.writeText "rootPassword" "notproduction";
    secrets = {
      secretFile = pkgs.writeText "secret" "Aig5zaic";
      otpFile = pkgs.writeText "otpsecret" "Riew9mue";
      dbFile = pkgs.writeText "dbsecret" "we2quaeZ";
      jwsFile = pkgs.runCommand "oidcKeyBase" { } "${pkgs.openssl}/bin/openssl genrsa 2048 > $out";
      activeRecordPrimaryKeyFile = pkgs.writeText "arprimary" "vsaYPZjTRxcbG7W6gNr95AwBmzFUd4Eu";
      activeRecordDeterministicKeyFile = pkgs.writeText "ardeterministic" "kQarv9wb2JVP7XzLTh5f6DFcMHms4nEC";
      activeRecordSaltFile = pkgs.writeText "arsalt" "QkgR9CfFU3MXEWGqa7LbP24AntK5ZeYw";
    };
    sidekiq.concurrency = 1;
    puma.workers = 2;
  };

  # Base node config. Each test runs a single VM, so peak memory stays at one node.
  commonNode = {
    nixpkgs.config = lib.mkForce { allowUnfree = true; };
    virtualisation.memorySize = 6144;
    virtualisation.cores = 4;
    virtualisation.useNixStoreImage = true;
    virtualisation.writableStore = false;
    # Fail fast on a license-load error instead of retrying forever, so the test
    # detects it rather than timing out waiting for the unit to go active.
    systemd.services.gitlab-db-config.serviceConfig.Restart = lib.mkForce "no";
    services.nginx = {
      enable = true;
      recommendedProxySettings = true;
      virtualHosts.localhost = {
        locations."/".proxyPass = "http://unix:/run/gitlab/gitlab-workhorse.socket";
      };
    };
  };

  # Shared testScript helpers, prepended to each test's script.
  helpers = ''
    import re

    def db_config_script(machine):
        """Return the content of the gitlab-db-config ExecStart script."""
        unit = machine.succeed("systemctl cat gitlab-db-config.service")
        m = re.search(r'ExecStart=(/nix/store/\S+)', unit)
        assert m, f"Could not find ExecStart path in unit:\n{unit}"
        return machine.succeed(f"cat {m.group(1)}")

    def wait_db_config(machine, timeout=900):
        """Wait for gitlab-db-config to reach a terminal state; assert it succeeded.

        With Restart=no the unit ends in active or failed, so we poll for either
        rather than only 'active' (which would hang on failure). On failure we dump
        the journal to surface the license-load error.
        """
        machine.wait_until_succeeds(
            "systemctl show -p ActiveState --value gitlab-db-config.service "
            "| grep -qE '^(active|failed)$'",
            timeout=timeout,
        )
        state = machine.succeed(
            "systemctl show -p ActiveState --value gitlab-db-config.service"
        ).strip()
        if state != "active":
            machine.execute(
                "journalctl -u gitlab-db-config.service --no-pager | tail -n 60 >&2"
            )
        assert state == "active", f"gitlab-db-config ended in state {state!r}"

    def license_plan(machine):
        """Return the plan of the currently active license, or 'NONE'."""
        return machine.succeed(
            "sudo -u gitlab -H gitlab-rails runner "
            "'l = License.current; print(l ? l.restrictions[:plan] : %q(NONE))' 2>/dev/null"
        ).strip()
  '';
}
