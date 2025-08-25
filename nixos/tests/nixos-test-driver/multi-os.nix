{ lib, hostPkgs, ... }:

let

  nixThePlanet = builtins.getFlake "github:MatthewCroughan/NixThePlanet/c9d159dc2e0049e7b250a767a3a01def52c3412b";

   # no specific commit in particular
  nix-darwin = builtins.getFlake "github:nix-darwin/nix-darwin/e04a388232d9a6ba56967ce5b53a8a6f713cdfcf";

  guestDarwin =
    let
      inherit (hostPkgs.stdenv) hostPlatform;
    in
      if hostPlatform.isDarwin then
        hostPlatform.system
      else
        let
          hostToGuest = {
            "x86_64-linux" = "x86_64-darwin";
            "aarch64-linux" = "aarch64-darwin";
          };

          supportedHosts = lib.concatStringsSep ", " (lib.attrNames hostToGuest);

          message = "NixOS Test: don't know which VM guest system to pair with VM host system: ${hostPlatform.system}. Perhaps you intended to run the tests on a Darwin host, or one of the following systems that may run NixOS tests: ${supportedHosts}";
        in
        hostToGuest.${hostPlatform.system} or (throw message);

  defaultDarwinModule = { config, name, ... }:
  {
    _file = "${__curPos.file}:${toString (__curPos.line - 1)}";
    imports = [ ./multi-os/qemu-vm.nix ];
    virtualisation.host.pkgs = hostPkgs;
  };

  darwinBaseEval = nix-darwin.lib.darwinSystem {
    system = guestDarwin;
    modules = [ defaultDarwinModule ];
  };

in

{
  name = "nixos-test-driver-multi-os";
  passthru = {
    /** NixThePlanet flake, for use in repl */
    inherit nixThePlanet;
    /** nix-darwin flake, for use in repl */
    inherit nix-darwin;
  };
  node.specialArgs = {
    inherit nixThePlanet;
  };
  nodes = {
    # A NixOS VM
    rose = { };
    # A macOS VM
    daisy = {
      system.stateVersion = 6;
      virtualisation.diskImage = "${nixThePlanet.packages.${hostPkgs.stdenv.hostPlatform.system}.macos-ventura-image}";
      virtualisation.qemu.options = [
        "-drive" "if=pflash,format=raw,readonly=on,file=${nixThePlanet.legacyPackages.${hostPkgs.stdenv.hostPlatform.system}.osx-kvm}/OVMF_CODE.fd"
        "-drive" "if=pflash,format=raw,readonly=on,file=${nixThePlanet.legacyPackages.${hostPkgs.stdenv.hostPlatform.system}.osx-kvm}/OVMF_VARS-1920x1080.fd"
        "-drive" "id=OpenCoreBoot,if=virtio,snapshot=on,readonly=on,format=qcow2,file=${nixThePlanet.legacyPackages.${hostPkgs.stdenv.hostPlatform.system}.osx-kvm}/OpenCore/OpenCore.qcow2"

      ];
    };
  };
  machines = {
    daisy = {
      osType = darwinBaseEval.type;

    };
  };
  testScript = ''
    # start_all();
    daisy.succeed("uname -s | tee /dev/stderr | grep '^Darwin$'");
  '';
}