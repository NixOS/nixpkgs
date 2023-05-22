{ config, lib, pkgs, ... }: {
  # Azure metadata is available as a CD-ROM drive.
  # But only before azure-signal-ready.service have run
  fileSystems."/metadata".device = "/dev/cdrom";
}