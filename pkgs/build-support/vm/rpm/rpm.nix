pkgs:

rec {

  stdenv = pkgs.stdenv;

  
  fillDiskWithRPMs = {size ? 1024, rpms, name, fullName, postInstall ? null}:
  stdenv.mkDerivation {
    builder = ./fill-disk-with-rpms.sh;
    worker = ./fill-disk-worker.sh;
    buildInputs = [pkgs.uml pkgs.utillinux];
    inherit (pkgs) sysvinit e2fsprogs rpm;
    inherit rpms size name fullName postInstall;
  };


  runInUML = args: stdenv.mkDerivation (args // {
    inherit (args) name image;
    builder = ./run-in-uml.sh;
    actualBuilder = args.builder;
    boot = ./run-in-uml-boot.sh;
    buildInputs = [pkgs.uml pkgs.utillinux];
    inherit (pkgs) sysvinit utillinux;
  });

    
  redhat90Image = fillDiskWithRPMs {
    rpms = (import ./redhat-9-packages.nix) {inherit (pkgs) fetchurl;};
    name = "redhat-9.0";
    fullName = "Red Hat 9.0";
    postInstall = ./redhat-postinstall.sh;
  };

  suse90Image = fillDiskWithRPMs {
    rpms = (import ./suse-9-packages.nix) {inherit (pkgs) fetchurl;};
    name = "suse-9.0";
    fullName = "SuSE 9.0";
  };

  fedora2Image = fillDiskWithRPMs {
    rpms = (import ./fedora-2-packages.nix) {inherit (pkgs) fetchurl;};
    name = "fedora-core-2";
    fullName = "Fedora Core 2";
    postInstall = ./fedora-postinstall.sh;
  };

  fedora3Image = fillDiskWithRPMs {
    rpms = (import ./fedora-3-packages.nix) {inherit (pkgs) fetchurl;};
    name = "fedora-core-3";
    fullName = "Fedora Core 3";
    postInstall = ./fedora-postinstall.sh;
  };

  fedora5Image = fillDiskWithRPMs {
    rpms = (import ./fedora-5-packages.nix) {inherit (pkgs) fetchurl;};
    name = "fedora-core-5";
    fullName = "Fedora Core 5";
  };
}
