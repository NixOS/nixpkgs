{ stdenv
, lib
, unstick
, fetchurl
, version
, supportedDevices
}:

let
  download = {name, sha256}: fetchurl {
    inherit name sha256;
    # e.g. "20.1.1.720" -> "20.1std.1/720"
    url = "https://downloads.intel.com/akdlm/software/acdsinst/${lib.versions.majorMinor version}std.${lib.versions.patch version}/${lib.elemAt (lib.splitVersion version) 3}/ib_installers/${name}";
  };
  installers = builtins.map download [
    {
      name = "QuartusLiteSetup-${version}-linux.run";
      sha256 = "0mjp1rg312dipr7q95pb4nf4b8fwvxgflnd1vafi3g9cshbb1c3k";
    }
    {
      name = "ModelSimSetup-${version}-linux.run";
      sha256 = "1cqgv8x6vqga8s4v19yhmgrr886rb6p7sbx80528df5n4rpr2k4i";
    }
  ];
  components = with builtins; lib.pipe supportedDevices [
    (mapAttrs (id: {name, hash}: {
      name = "${id}-${version}.qdz";
      sha256 = hash;
    }))
    (attrValues)
    (map download)
  ];
in stdenv.mkDerivation {
  inherit version;
  pname = "quartus-prime-lite-unwrapped";

  src = installers ++ components;

  nativeBuildInputs = [ unstick ];

  buildCommand = let
    copyInstaller = installer: ''
        # `$(cat $NIX_CC/nix-support/dynamic-linker) $src[0]` often segfaults, so cp + patchelf
        cp ${installer} $TEMP/${installer.name}
        chmod u+w,+x $TEMP/${installer.name}
        patchelf --interpreter $(cat $NIX_CC/nix-support/dynamic-linker) $TEMP/${installer.name}
      '';
    copyComponent = component: "cp ${component} $TEMP/${component.name}";
    # leaves enabled: quartus, modelsim_ase, devinfo
    disabledComponents = [
      "quartus_help"
      "quartus_update"
      # not modelsim_ase
      "modelsim_ae"
    ];
  in ''
      ${lib.concatMapStringsSep "\n" copyInstaller installers}
      ${lib.concatMapStringsSep "\n" copyComponent components}

      unstick $TEMP/${(builtins.head installers).name} \
        --disable-components ${lib.concatStringsSep "," disabledComponents} \
        --mode unattended --installdir $out --accept_eula 1

      rm -r $out/uninstall $out/logs
    '';

  meta = with lib; {
    homepage = "https://fpgasoftware.intel.com";
    description = "FPGA design and simulation software";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ kwohlfahrt ];
  };
}
