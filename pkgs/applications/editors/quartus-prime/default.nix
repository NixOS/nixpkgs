{ stdenv, lib, buildFHSUserEnv, callPackage, makeDesktopItem, writeScript
, supportedDevices ? [ "Arria II" "Cyclone V" "Cyclone IV" "Cyclone 10 LP" "MAX II/V" "MAX 10 FPGA" ]
, unwrapped ? callPackage ./quartus.nix { inherit supportedDevices; }
}:

let
  desktopItem = makeDesktopItem {
    name = "quartus-prime-lite";
    exec = "quartus";
    icon = "quartus";
    desktopName = "Quartus";
    genericName = "Quartus Prime";
    categories = [ "Development" ];
  };
# I think modelsim_ase/linux/vlm checksums itself, so use FHSUserEnv instead of `patchelf`
in buildFHSUserEnv rec {
  name = "quartus-prime-lite"; # wrapped

  targetPkgs = pkgs: with pkgs; [
    # quartus requirements
    glib
    xorg.libICE
    xorg.libSM
    zlib
    # qsys requirements
    xorg.libXtst
    xorg.libXi
    libudev0-shim
  ];
  multiPkgs = pkgs: with pkgs; let
    # This seems ugly - can we override `libpng = libpng12` for all `pkgs`?
    freetype = pkgs.freetype.override { libpng = libpng12; };
    fontconfig = pkgs.fontconfig.override { inherit freetype; };
    libXft = pkgs.xorg.libXft.override { inherit freetype fontconfig; };
  in [
    # modelsim requirements
    libxml2
    ncurses5
    unixODBC
    libXft
    # common requirements
    freetype
    fontconfig
    xorg.libX11
    xorg.libXext
    xorg.libXrender
  ];

  passthru = { inherit unwrapped; };

  extraInstallCommands = let
    quartusExecutables = (map (c: "quartus/bin/quartus_${c}") [
      "asm" "cdb" "cpf" "drc" "eda" "fit" "jbcc" "jli" "map" "pgm" "pow"
      "sh" "si" "sim" "sta" "stp" "tan"
    ]) ++ [ "quartus/bin/quartus" ];

    qsysExecutables = map (c: "quartus/sopc_builder/bin/qsys-${c}") [
      "generate" "edit" "script"
    ];
    # Should we install all executables ?
    modelsimExecutables = map (c: "modelsim_ase/bin/${c}") [
      "vsim" "vlog" "vlib"
    ];
  in ''
    mkdir -p $out/share/applications $out/share/icons/128x128
    ln -s ${desktopItem}/share/applications/* $out/share/applications
    ln -s ${unwrapped}/licenses/images/dc_quartus_panel_logo.png $out/share/icons/128x128/quartus.png

    mkdir -p $out/quartus/bin $out/quartus/sopc_builder/bin $out/modelsim_ase/bin
    WRAPPER=$out/bin/${name}
    EXECUTABLES="${lib.concatStringsSep " " (quartusExecutables ++ qsysExecutables ++ modelsimExecutables)}"
    for executable in $EXECUTABLES; do
        echo "#!${stdenv.shell}" >> $out/$executable
        echo "$WRAPPER ${unwrapped}/$executable \$@" >> $out/$executable
    done

    cd $out
    chmod +x $EXECUTABLES
    # link into $out/bin so executables become available on $PATH
    ln --symbolic --relative --target-directory ./bin $EXECUTABLES
  '';

  runScript = writeScript "${name}-wrapper" ''
    exec $@
  '';
}
