# Common definition used by ClamAV tests.
#
# ClamAV requires at least one definition to start.
# We add a custom definition as we cannot download them from Internet using freshclam in sandboxed test.

{ lib, pkgs, ... }:
{
  # Add the definition for our test file.
  # We cannot download definitions from Internet using freshclam in sandboxed test.
  systemd.tmpfiles.settings."10-test"."/var/lib/clamav/test.hdb".L.argument = "${pkgs.runCommand
    "test.hdb"
    { }
    ''
      echo CLAMAVTEST > testfile
      ${lib.getExe' pkgs.clamav "sigtool"} --sha256 testfile > $out
    ''
  }";

  # Test using /opt as the ClamAV on-access scanner-protected directory.
  systemd.tmpfiles.settings."10-testdir"."/opt".d = { };
}
