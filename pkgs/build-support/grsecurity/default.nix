{ pkgs, lib, ... }:

with pkgs;
with lib;

let
  grsec_path_patch = { name "grsec-path"; patch = ./grsec-path.patch; };
  genericKernelBuilder = import ../../os-specific/linux/kernel/generic.nix;
in
{
  customGrsecKernelPackages = p:
    let
      version  = p.kernel.version;
      localver = p.kernel.localver or "";
      modDirVersion = p.kernel.modDirVersion or (version+localver);
      features = p.kernel.features or {};
      src = with p.kernel; fetchurl { inherit url sha256; };

      kernel = overrideDerivation (genericKernelBuilder (rec {
        inherit version modDirVersion src;

        /* Add any 'quirky' patches (like bridge_stp_helper and
         * grsec_path_patch, which fix NixOS-specific quirks) plus the ones
         * the user specified. */
        kernelPatches = [ grsec_path_patch
                          kernelPatches.bridge_stp_helper
                        ] ++ (map fetchurl p.patches);

        /* Default features */
        features.iwlwifi = true;
        features.efiBootStub = true;
        features.needsCifsUtils = true;
        features.canDisableNetfilterConntrackHelpers = true;
        features.netfilterRPFilter = true;
      })) (args: {
        # Apparently as of gcc 4.6, gcc-plugin headers (which are needed by PaX plugins)
        # include libgmp headers, so we need these extra tweaks
        buildInputs = args.buildInputs ++ [ pkgs.gmp ];
        preConfigure = ''
          ${args.preConfigure or ""}
          sed -i 's|-I|-I${pkgs.gmp}/include -I|' scripts/gcc-plugin.sh
          sed -i 's|HOST_EXTRACFLAGS +=|HOST_EXTRACFLAGS += -I${pkgs.gmp}/include|' tools/gcc/Makefile
          sed -i 's|HOST_EXTRACXXFLAGS +=|HOST_EXTRACXXFLAGS += -I${pkgs.gmp}/include|' tools/gcc/Makefile
          rm localversion-grsec
          ${if localver == "" then "" else ''
            echo ${localver} > localversion-nix
          ''}
        '';
      }) // features;

     kernelPackages = let self = linuxPackagesFor kernel self; in recurseIntoAttrs self;
  in {
    inherit kernel;
    inherit kernelPackages;
  };
}
