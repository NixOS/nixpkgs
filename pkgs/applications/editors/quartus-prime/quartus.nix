{ stdenv, lib, unstick, fetchurl
, supportedDevices ? [ "Arria II" "Cyclone V" "Cyclone IV" "Cyclone 10 LP" "MAX II/V" "MAX 10 FPGA" ]
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
    assert lib.assertMsg (lib.all (name: lib.hasAttr name deviceIds) supportedDevices)
      "Supported devices are: ${lib.concatStringsSep ", " (lib.attrNames deviceIds)}";
    lib.listToAttrs (map (name: {
      inherit name;
      value = deviceIds.${name};
    }) supportedDevices);

  unsupportedDeviceIds = lib.filterAttrs (name: value:
    !(lib.hasAttr name supportedDeviceIds)
  ) deviceIds;

  componentHashes = {
    "arria_lite" = "07p862i3dn2c0s3p39y23g94id59nzrpzbwdmrdnhy61ca3m0vzp";
    "cyclone" = "0dic35j9q1ndrn8i2vdqg9176fr3kn6c8iiv0c03nni0m4ar3ykn";
    "cyclone10lp" = "03w4f71fhhwvnkzzly9m15nrdf0jw8m0ckhhzv1vg3nd9pkk86jh";
    "cyclonev" = "091mlg2iy452fk28idbiwi3rhcgkbhg7ggh3xvnqa9jrfffq9pjc";
    "max" = "0r649l2n6hj6x5v6hx8k4xnvd6df6wxajx1xp2prq6dpapjfb06y";
    "max10" = "1p5ds3cq2gq2mzq2hjwwjhw50c931kgiqxaf7ss228c6s7rv6zpk";
  };

  version = "22.1std.2.922";

  download = {name, sha256}: fetchurl {
    inherit name sha256;
    # e.g. "22.1std.2.922" -> "22.1std.2/922"
    url = "https://downloads.intel.com/akdlm/software/acdsinst/${lib.versions.majorMinor version}std.${lib.elemAt (lib.splitVersion version) 3}/${lib.elemAt (lib.splitVersion version) 4}/ib_installers/${name}";
  };

in stdenv.mkDerivation rec {
  inherit version;
  pname = "quartus-prime-lite-unwrapped";

  src = map download ([{
    name = "QuartusLiteSetup-${version}-linux.run";
    sha256 = "078x42pbc51n6ynrvzpwiwgi6g2sg4csv6x2vnnzjgx6bg5kq6l3";
  } {
    name = "QuestaSetup-${version}-linux.run";
    sha256 = "04pv5fq3kfy3xsjnj435zzpj5kf6329cbs1xgvkgmq1gpn4ji5zy";
  }] ++ (map (id: {
    name = "${id}-${version}.qdz";
    sha256 = lib.getAttr id componentHashes;
  }) (lib.attrValues supportedDeviceIds)));

  nativeBuildInputs = [ unstick ];

  buildCommand = let
    installers = lib.sublist 0 2 src;
    components = lib.sublist 2 ((lib.length src) - 2) src;
    copyInstaller = installer: ''
        # `$(cat $NIX_CC/nix-support/dynamic-linker) $src[0]` often segfaults, so cp + patchelf
        cp ${installer} $TEMP/${installer.name}
        chmod u+w,+x $TEMP/${installer.name}
        patchelf --interpreter $(cat $NIX_CC/nix-support/dynamic-linker) $TEMP/${installer.name}
      '';
    copyComponent = component: "cp ${component} $TEMP/${component.name}";
    # leaves enabled: quartus, questa_fse, devinfo
    disabledComponents = [
      "quartus_help"
      "quartus_update"
      # not questa_fse
      "questa_fe"
    ] ++ (lib.attrValues unsupportedDeviceIds);
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
