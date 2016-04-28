{ pkgs, python34Packages, nix }:

python34Packages.buildPythonPackage rec {
  name = "fc-manage-${version}";
  version = "1.0";
  namePrefix = "";
  dontStrip = true;
  src = ./.;
  propagatedBuildInputs = with pkgs;
    [ gptfdisk
      lvm2
      multipath_tools
      utillinux
      xfsprogs
      fcmaintenance
      nix
    ];
}
