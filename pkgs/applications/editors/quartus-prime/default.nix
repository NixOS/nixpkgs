{ stdenv
, lib
, buildFHSUserEnv
, callPackage
, makeDesktopItem
, writeScript
, version ? "20.1.1.720"
, supportedDevices ? {
  arria_lite = {
    name = "Arria II";
    hash = "140jqnb97vrxx6398cpgpw35zrrx3z5kv1x5gr9is1xdbnf4fqhy";
  };
  cyclonev = {
    name = "Cyclone V";
    hash = "11baa9zpmmfkmyv33w1r57ipf490gnd3dpi2daripf38wld8lgak";
  };
  cyclone = {
    name = "Cyclone IV";
    hash = "116kf69ryqcmlc2k8ra0v32jy7nrk7w4s5z3yll7h3c3r68xcsfr";
  };
  cyclone10lp = {
    name = "Cyclone 10 LP";
    hash = "07wpgx9bap6rlr5bcmr9lpsxi3cy4yar4n3pxfghazclzqfi2cyl";
  };
  max = {
    name = "MAX II/V";
    hash = "1zy2d42dqmn97fwmv4x6pmihh4m23jypv3nd830m1mj7jkjx9kcq";
  };
  max10 = {
    name = "MAX 10 FPGA";
    hash = "1hvi9cpcjgbih3l6nh8x1vsp0lky5ax85jb2yqmzla80n7dl9ahs";
  };
}
, unwrapped ? callPackage ./quartus.nix { inherit version supportedDevices; }
}:

let
  name = "quartus-prime-lite";
  desktopItem = makeDesktopItem {
    inherit name;
    exec = "quartus";
    icon = "quartus";
    desktopName = "Quartus";
    genericName = "Quartus Prime";
    categories = [ "Development" ];
  };
# I think modelsim_ase/linux/vlm checksums itself, so use FHSUserEnv instead of `patchelf`
in buildFHSUserEnv {
  inherit name;

  targetPkgs = pkgs: with pkgs; [
    # quartus requirements
    glib
    xorg.libICE
    xorg.libSM
    zlib
    # qsys requirements
    xorg.libXtst
    xorg.libXi
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
    libudev0-shim
    libxcrypt
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
        echo "$WRAPPER ${unwrapped}/$executable \"\$@\"" >> $out/$executable
    done

    cd $out
    chmod +x $EXECUTABLES
    # link into $out/bin so executables become available on $PATH
    ln --symbolic --relative --target-directory ./bin $EXECUTABLES
  '';

  # LD_PRELOAD fixes issues in the licensing system that cause memory corruption and crashes when
  # starting most operations in many containerized environments, including WSL2, Docker, and LXC
  # (a similiar fix involving LD_PRELOADing tcmalloc did not solve the issue in my situation)
  # we use the name so that quartus can load the 64 bit verson and modelsim can load the 32 bit version
  # https://community.intel.com/t5/Intel-FPGA-Software-Installation/Running-Quartus-Prime-Standard-on-WSL-crashes-in-libudev-so/m-p/1189032
  runScript = writeScript "${name}-wrapper" ''
    exec env LD_PRELOAD=libudev.so.0 "$@"
  '';
}
