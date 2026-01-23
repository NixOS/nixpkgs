{
  stdenv,
  lib,
  unstick,
  fetchurl,
  withQuesta ? true,
  supportedDevices ? [
    "Arria II"
    "Cyclone V"
    "Cyclone IV"
    "Cyclone 10 LP"
    "MAX II/V"
    "MAX 10 FPGA"
  ],
}:

let
  deviceIds = {
    "Arria II" = "arria_lite";
    "Cyclone V" = "cyclonev";
    "Cyclone IV" = "cyclone";
    "Cyclone 10 LP" = "cyclone10lp";
    "MAX II/V" = "max";
    "MAX 10 FPGA" = "max10";
  };

  supportedDeviceIds =
    assert lib.assertMsg (lib.all (
      name: lib.hasAttr name deviceIds
    ) supportedDevices) "Supported devices are: ${lib.concatStringsSep ", " (lib.attrNames deviceIds)}";
    lib.listToAttrs (
      map (name: {
        inherit name;
        value = deviceIds.${name};
      }) supportedDevices
    );

  unsupportedDeviceIds = lib.removeAttrs deviceIds (lib.attrNames supportedDeviceIds);

  componentHashes = {
    "arria_lite" = "sha256-Epxvu1z7Z4vQWASIYEJAy5P7Meee114ZNVIAZnmTEH8=";
    "cyclone" = "sha256-lKOYy61BHxY4OyonxADg6d7IGwckGX8zu0x6dpGB5Lo=";
    "cyclone10lp" = "sha256-lurSlhCuE6i2ULKNFvlWNtk6rqdvVwREC607HbMSH2I=";
    "cyclonev" = "sha256-1uSE/RsKR3hbyLzTGOQn1Ml5j5J26e+SmFI1hl9ry28=";
    "max" = "sha256-jY/b906fJKgJOL3h5nWR5RQdvAJ3U9of6y4VopGo2z0=";
    "max10" = "sha256-gFeESwuRwrp+8rN7GYbRmOxPGDHMm+ClLRjl/rTBnOk=";
  };

  version = "25.1std.0.1129";

  download =
    { name, sha256 }:
    fetchurl {
      inherit name sha256;
      # e.g. "23.1std.1.993" -> "23.1std/993"
      url = "https://downloads.intel.com/akdlm/software/acdsinst/${lib.versions.majorMinor version}std/${lib.elemAt (lib.splitVersion version) 4}/ib_installers/${name}";
    };

  installers = map download (
    [
      {
        name = "QuartusLiteSetup-${version}-linux.run";
        sha256 = "sha256-UYQz7H3NYXJVYK9lM1P3pcMgzOnlKLInR7io3zZ0xOs=";
      }
    ]
    ++ lib.optional withQuesta {
      name = "QuestaSetup-${version}-linux.run";
      sha256 = "sha256-0F7psE+jTimCoy+UVJRgxNC6GEVdY/PJu49hf+D7T3U=";
    }
  );
  components = map (
    id:
    download {
      name = "${id}-${version}.qdz";
      sha256 = lib.getAttr id componentHashes;
    }
  ) (lib.attrValues supportedDeviceIds);

in
stdenv.mkDerivation {
  inherit version;
  pname = "quartus-prime-lite-unwrapped";

  nativeBuildInputs = [ unstick ];

  buildCommand =
    let
      copyInstaller = installer: ''
        # `$(cat $NIX_CC/nix-support/dynamic-linker) $src[0]` often segfaults, so cp + patchelf
        cp ${installer} $TEMP/${installer.name}
        chmod u+w,+x $TEMP/${installer.name}
        patchelf --interpreter $(cat $NIX_CC/nix-support/dynamic-linker) $TEMP/${installer.name}
      '';
      copyComponent = component: "cp ${component} $TEMP/${component.name}";
      # leaves enabled: quartus, devinfo
      disabledComponents = [
        "quartus_help"
        "quartus_update"
        "questa_fe"
      ]
      ++ (lib.optional (!withQuesta) "questa_fse")
      ++ (lib.attrValues unsupportedDeviceIds);
    in
    ''
      echo "setting up installer..."
      ${lib.concatMapStringsSep "\n" copyInstaller installers}
      ${lib.concatMapStringsSep "\n" copyComponent components}

      echo "executing installer..."
      # "Could not load seccomp program: Invalid argument" might occur if unstick
      # itself is compiled for x86_64 instead of the non-x86 host. In that case,
      # override the input.
      unstick $TEMP/${(builtins.head installers).name} \
        --disable-components ${lib.concatStringsSep "," disabledComponents} \
        --mode unattended --installdir $out --accept_eula 1

      echo "cleaning up..."
      rm -r $out/uninstall $out/logs

      # replace /proc pentium check with a true statement. this allows usage under emulation.
      substituteInPlace $out/quartus/adm/qenv.sh \
        --replace-fail 'grep sse /proc/cpuinfo > /dev/null 2>&1' ':'
    '';

  meta = {
    homepage = "https://fpgasoftware.intel.com";
    description = "FPGA design and simulation software";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [
      bjornfor
      kwohlfahrt
      zainkergaye
    ];
  };
}
