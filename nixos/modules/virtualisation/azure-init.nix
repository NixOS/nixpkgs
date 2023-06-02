{ config, lib, pkgs, ... }:
{
  # Azure metadata is available as a CD-ROM drive.
  fileSystems."/metadata".device = "/dev/sr0";
}