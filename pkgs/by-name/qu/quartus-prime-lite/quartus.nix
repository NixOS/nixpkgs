{
  stdenv,
  lib,
  unstick,
  unzip,
  fetchurl,
  variant,
  withQuesta ? true,
  supportedDevices ? [
    "Arria II"
    "Cyclone V"
    "Cyclone IV"
    "Cyclone 10 LP"
    "MAX II/V"
    "MAX 10 FPGA"
  ],
  # leaves enabled: quartus, devinfo
  disabledComponents ? [
    "quartus_help"
    "quartus_update"
    "questa_fe"
  ],
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "quartus-prime-${variant}-unwrapped";
  version = finalAttrs.passthru.version';

  nativeBuildInputs = [
    unstick
    # The devices' .qdz files are actually zip files, and without `unzip` here
    # they are failed to be extracted because the installer tries to run its
    # own `unzip` utility.
    unzip
  ];

  buildCommand = ''
    echo "setting up installer..."
  ''
  + lib.pipe finalAttrs.finalPackage.passthru.installers [
    (lib.mapAttrsToList finalAttrs.finalPackage.passthru.download)
    # NOTE that we don't have a choice but to `cp` the installers and not
    # symlink them, because the installers lookup for `.qdz` files by looking
    # at the directory of their real, symlink-resolved location. We can however
    # symlink the `.qdz` files to `$TEMP`.
    (map (installer: ''
      # `$(cat $NIX_CC/nix-support/dynamic-linker) $src[0]` often segfaults, so cp + patchelf
      cp ${installer} $TEMP/${installer.name}
      chmod u+w,+x $TEMP/${installer.name}
      patchelf --interpreter $(cat $NIX_CC/nix-support/dynamic-linker) $TEMP/${installer.name}
    ''))
    lib.concatLines
  ]
  + lib.pipe finalAttrs.finalPackage.passthru.installerParts [
    (lib.mapAttrsToList finalAttrs.finalPackage.passthru.download)
    (map (installerPart: "ln -s ${installerPart} $TEMP/${installerPart.name}"))
    lib.concatLines
  ]
  + (
    let
      availableDevices = lib.pipe finalAttrs.finalPackage.passthru.deviceIds [
        lib.attrNames
        lib.naturalSort
      ];
      unsupportedRequestedDevices = lib.pipe supportedDevices [
        (lib.subtractLists availableDevices)
        lib.naturalSort
      ];
    in
    assert lib.assertMsg (unsupportedRequestedDevices == [ ]) ''
      Unsupported devices requested:
      ${lib.concatMapStringsSep "\n" (d: " - ${d}") unsupportedRequestedDevices}
      Supported devices are:
      ${lib.concatMapStringsSep "\n" (d: " - ${d}") availableDevices}
    '';
    lib.pipe supportedDevices [
      (map (name: finalAttrs.finalPackage.passthru.deviceIds.${name}))
      (ids: lib.getAttrs ids finalAttrs.finalPackage.passthru.components)
      (lib.mapAttrsToList (
        id: hash: finalAttrs.finalPackage.passthru.download "${id}-${finalAttrs.version}.qdz" hash
      ))
      # See NOTE above `map` that iterates the installers.
      (map (component: "ln -s ${component} $TEMP/${component.name}"))
      lib.concatLines
    ]
  )
  + ''
    echo "executing installer..."
    # "Could not load seccomp program: Invalid argument" might occur if unstick
    # itself is compiled for x86_64 instead of the non-x86 host. In that case,
    # override the input.
    unstick $TEMP/${finalAttrs.finalPackage.passthru.mainInstaller} \
      --disable-components ${
        lib.concatStringsSep "," (
          disabledComponents
          ++ lib.optional (!withQuesta) "questa_fse"
          ++ lib.attrValues (lib.removeAttrs finalAttrs.finalPackage.passthru.deviceIds supportedDevices)
        )
      } \
      --mode unattended --installdir $out --accept_eula 1

    echo "installer log:"
    cat "$out/logs/quartus-${finalAttrs.version}-linux-install.log"

    echo "cleaning up..."
    rm -r $out/uninstall $out/logs

    # replace /proc pentium check with a true statement. this allows usage under emulation.
    substituteInPlace $out/quartus/adm/qenv.sh \
      --replace-fail 'grep ${
        if variant == "pro" then "sse4_2" else "sse"
      } /proc/cpuinfo > /dev/null 2>&1' ':'
  '';

  passthru =
    {
      lite = {
        version' = "25.1std.0.1129";
        deviceIds = {
          "Arria II" = "arria_lite";
          "Cyclone V" = "cyclonev";
          "Cyclone IV" = "cyclone";
          "Cyclone 10 LP" = "cyclone10lp";
          "MAX II/V" = "max";
          "MAX 10 FPGA" = "max10";
        };
        components = {
          "arria_lite" = "sha256-Epxvu1z7Z4vQWASIYEJAy5P7Meee114ZNVIAZnmTEH8=";
          "cyclone" = "sha256-lKOYy61BHxY4OyonxADg6d7IGwckGX8zu0x6dpGB5Lo=";
          "cyclone10lp" = "sha256-lurSlhCuE6i2ULKNFvlWNtk6rqdvVwREC607HbMSH2I=";
          "cyclonev" = "sha256-1uSE/RsKR3hbyLzTGOQn1Ml5j5J26e+SmFI1hl9ry28=";
          "max" = "sha256-jY/b906fJKgJOL3h5nWR5RQdvAJ3U9of6y4VopGo2z0=";
          "max10" = "sha256-gFeESwuRwrp+8rN7GYbRmOxPGDHMm+ClLRjl/rTBnOk=";
        };
        installers = {
          "QuartusLiteSetup-${finalAttrs.version}-linux.run" =
            "sha256-UYQz7H3NYXJVYK9lM1P3pcMgzOnlKLInR7io3zZ0xOs=";
        }
        // lib.optionalAttrs withQuesta {
          "QuestaSetup-${finalAttrs.version}-linux.run" =
            "sha256-0F7psE+jTimCoy+UVJRgxNC6GEVdY/PJu49hf+D7T3U=";
        };
        installerParts = { };
        mainInstaller = "QuartusLiteSetup-${finalAttrs.version}-linux.run";
      };
      standard = {
        version' = "25.1std.0.1129";
        deviceIds = {
          "Arria II" = "arria";
          "Arria V" = "arriav";
          "Arria V GZ" = "arriavgz";
          "Arria 10" = "arria10";
          "Cyclone V" = "cyclonev";
          "Cyclone IV" = "cyclone";
          "Cyclone 10 LP" = "cyclone10lp";
          "MAX II/V" = "max";
          "MAX 10 FPGA" = "max10";
          "Stratix IV" = "stratixiv";
          "Stratix V" = "stratixv";
        };
        components = {
          arria = "sha256-BNfOuJ7e4s3hVNx6J6+UEh4NWW+5z0Muz6Ty7NfVkf0=";
          arria10 = "sha256-v3cfAu7qX4uerHH0uJWsi4uK+sSMfdyprqXyWThrYzY=";
          arriav = "sha256-WpQAJE6OrGcQhxINkLYJt6KP1zn/LmU6KkDklCl8vSU=";
          arriavgz = "sha256-1jgeM3u/tdjwh5k38UblHq2a/Y/iwT8qI3pOA12RIPg=";
          cyclone = "sha256-lKOYy61BHxY4OyonxADg6d7IGwckGX8zu0x6dpGB5Lo=";
          cyclone10lp = "sha256-lurSlhCuE6i2ULKNFvlWNtk6rqdvVwREC607HbMSH2I=";
          cyclonev = "sha256-1uSE/RsKR3hbyLzTGOQn1Ml5j5J26e+SmFI1hl9ry28=";
          max = "sha256-jY/b906fJKgJOL3h5nWR5RQdvAJ3U9of6y4VopGo2z0=";
          max10 = "sha256-gFeESwuRwrp+8rN7GYbRmOxPGDHMm+ClLRjl/rTBnOk=";
          stratixiv = "sha256-DalqBhE/97sAt015o4hUmo93NBKGSFJPPZO49YcoSMM=";
          stratixv = "sha256-UJbBk6UQ/DKm1Uvl5o3FUPYDvai95t8Obb/c1It0fjg=";
        };
        installers = {
          "QuartusSetup-${finalAttrs.version}-linux.run" =
            "sha256-b++VtYqGBXW+yYEMddMjk8bwH0oiLmjb143Of6QDoog=";
        }
        // lib.optionalAttrs withQuesta {
          "QuestaSetup-${finalAttrs.version}-linux.run" =
            "sha256-0F7psE+jTimCoy+UVJRgxNC6GEVdY/PJu49hf+D7T3U=";
        };
        installerParts = { };
        mainInstaller = "QuartusSetup-${finalAttrs.version}-linux.run";
      };
      pro = {
        # Quartus Prime Pro doesn't provide device files for Cyclone 10 GX or Arria 10 on x.x.1 releases
        version' = "26.1.0.110";
        deviceIds = {
          "Agilex common files" = "agilex_common";
          "Agilex 3" = "agilex3";
          "Agilex 5" = "agilex5";
          "Agilex 7" = "agilex7";
          "Arria 10" = "arria10";
          "Cyclone 10 GX" = "cyclone10gx";
          "Stratix 10" = "stratix10";
        };
        components = {
          agilex_common = "sha256-iP/AwGnSVpUFk3pqp6r920ldHQnmBaZY5SWf8XpPtAM=";
          agilex3 = "sha256-XSaV+NbeEYh5CMWnUqvz0cW3PaKhdzXAz8GdoA/cgi4=";
          agilex5 = "sha256-sceVIybyPDQ/KPyQpefPfD15WzwclnesV7nHPN3MgCc=";
          agilex7 = "sha256-dUF0qDZefP+ssxs2u0n6pssbKr4CTe4KU4A3Uo3UiB0=";
          arria10 = "sha256-xvAp5Hrd/zukIyNxviaXHZwLjrF6Q+AIneyzk0xKSng=";
          cyclone10gx = "sha256-bkwkBButejpJpkXSpwHNxk1ko6iqZDnsDwxb85k8Nfs=";
          stratix10 = "sha256-uBUKcYcN1FcKrzTumzFnyVZ5pR9jT9Y4a94FXC9TWCA=";
        };
        installers = {
          "QuartusProSetup-${finalAttrs.version}-linux.run" =
            "sha256-hE8qbaRDCvEDlpbz0Stmn9WBPgPuJr0flN3Inx03RjI=";
        }
        // lib.optionalAttrs withQuesta {
          "QuestaSetup-${finalAttrs.version}-linux.run" =
            "sha256-79ZqW7CRTWqzm+VqKAJbbzJnBKfRA19uzQRIBj19aoo=";
        };
        installerParts = {
          "QuartusProSetup-part2-${finalAttrs.version}.qdz" =
            "sha256-fQDStWkoq4+CJsWefckZaofm603w217GefFyELMhUrs=";
        };
        mainInstaller = "QuartusProSetup-${finalAttrs.version}-linux.run";
      };
    }
    .${variant}
    // {
      # Make it a bit easier to override the download URL schema.
      baseURL = "https://download.altera.com/akdlm/software/acdsinst";
      # e.g.
      # "23.1std.1.993" -> "23.1std.1/993"
      # "24.1std.0.1077" -> "24.1std/1077"
      # "26.1.1.130" -> "26.1.1/130"
      # "26.1.0.110" -> "26.1/110"
      URLdir =
        let
          split = lib.splitString "." finalAttrs.version;
          patch = builtins.elemAt split 2;
          shortVer = builtins.concatStringsSep "." (
            (lib.take 2 split) ++ (lib.optional (patch != "0") patch)
          );
        in
        "${shortVer}/${builtins.elemAt split 3}/ib_installers";
      download =
        name: hash:
        fetchurl {
          inherit name hash;
          url = "${finalAttrs.finalPackage.baseURL}/${finalAttrs.finalPackage.URLdir}/${name}";
          curlOptsList = [
            "--user-agent"
            "Alterabot/1.0"
          ];
        };
    };

  meta = {
    homepage = "https://www.altera.com/downloads/fpga-development-tools/quartus-prime-${variant}-current";
    description = "FPGA design and simulation software";
    mainProgram = "quartus";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [
      bjornfor
      kwohlfahrt
      zainkergaye
      doronbehar
      Mop-u
    ];
  };
})
