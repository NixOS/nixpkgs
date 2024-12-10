# Vagrant + VirtualBox

{ config, pkgs, ... }:

{
  imports = [
    ./vagrant-guest.nix
    ./virtualbox-image.nix
  ];

  virtualbox.params = {
    audio = "none";
    audioin = "off";
    audioout = "off";
    usb = "off";
    usbehci = "off";
  };
  sound.enable = false;
  documentation.man.enable = false;
  documentation.nixos.enable = false;

  users.extraUsers.vagrant.extraGroups = [ "vboxsf" ];

  # generate the box v1 format which is much easier to generate
  # https://www.vagrantup.com/docs/boxes/format.html
  system.build.vagrantVirtualbox = pkgs.runCommand "virtualbox-vagrant.box" { } ''
    mkdir workdir
    cd workdir

    # 1. create that metadata.json file
    echo '{"provider":"virtualbox"}' > metadata.json

    # 2. create a default Vagrantfile config
    cat <<VAGRANTFILE > Vagrantfile
    Vagrant.configure("2") do |config|
      config.vm.base_mac = "0800275F0936"
    end
    VAGRANTFILE

    # 3. add the exported VM files
    tar xvf ${config.system.build.virtualBoxOVA}/*.ova

    # 4. move the ovf to the fixed location
    mv *.ovf box.ovf

    # 5. generate OVF manifest file
    rm *.mf
    touch box.mf
    for fname in *; do
      checksum=$(sha256sum $fname | cut -d' ' -f 1)
      echo "SHA256($fname)= $checksum" >> box.mf
    done

    # 6. compress everything back together
    tar --owner=0 --group=0 --sort=name --numeric-owner -czf $out .
  '';
}
