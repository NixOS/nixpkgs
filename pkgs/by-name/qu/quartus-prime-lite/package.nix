{
  lib,
  buildFHSEnv,
  callPackage,
  makeDesktopItem,
  runtimeShell,
  runCommand,
  writeShellScriptBin,
  xdg-utils,
  unstick,
  libfaketime,
  pkgsi686Linux,
  withQuesta ? true,
  supportedDevices ? [
    "Arria II"
    "Cyclone V"
    "Cyclone IV"
    "Cyclone 10 LP"
    "MAX II/V"
    "MAX 10 FPGA"
  ],
  unwrapped ? callPackage ./quartus.nix { inherit unstick supportedDevices withQuesta; },
  extraProfile ? "",
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
  # Quartus's own launcher (quartus/adm/qenv.sh) prepends quartus/linux64
  # (which bundles an older libstdc++.so.6) to LD_LIBRARY_PATH for its whole
  # session. When a user clicks a web link, Quartus execs `xdg-open` (found
  # via $PATH) to open it, and that process inherits the polluted
  # LD_LIBRARY_PATH, causing the browser it eventually launches to pick up
  # Quartus's outdated libstdc++ instead of its own and fail to start. Shadow
  # `xdg-open` on $PATH with a wrapper that restores the environment's
  # original LD_LIBRARY_PATH (conveniently saved by qenv.sh as
  # $QUARTUS_ORIG_LIBPATH) before delegating to nixpkgs' own xdg-utils
  # xdg-open.
  xdgOpenWrapper = writeShellScriptBin "xdg-open" ''
    export LD_LIBRARY_PATH=$QUARTUS_ORIG_LIBPATH
    exec ${lib.getExe' xdg-utils "xdg-open"} "$@"
  '';
in
# I think questa_fse/linux/vlm checksums itself, so use FHSUserEnv instead of `patchelf`
buildFHSEnv (finalAttrs: {
  pname = "quartus-prime-lite"; # wrapped
  inherit (unwrapped) version;

  targetPkgs =
    pkgs: with pkgs; [
      (runCommand "ld-lsb-compat" { } (
        ''
          mkdir -p "$out/lib"
          ln -sr "${glibc}/lib/ld-linux-x86-64.so.2" "$out/lib/ld-lsb-x86-64.so.3"
        ''
        + lib.optionalString withQuesta ''
          ln -sr "${pkgsi686Linux.glibc}/lib/ld-linux.so.2" "$out/lib/ld-lsb.so.3"
        ''
      ))
      # quartus requirements
      glib
      libice
      libsm
      libxau
      libxdmcp
      libxscrnsaver
      libudev0-shim
      bzip2
      brotli
      expat
      dbus
      # qsys requirements
      libxtst
      libxi
      dejavu_fonts
      gnumake
    ];

  # Also support 32-bit executables used by simulator.
  multiArch = withQuesta;

  # these libs are installed as 64 bit, plus as 32 bit when multiArch is true
  multiPkgs =
    pkgs:
    with pkgs;
    let
      # NOTE: Not using `pkgs.extend` here on purpose: `pkgs` here is
      # `pkgsi686Linux`, a spliced package set (see the "splicing code does not
      # handle `pkgsi686Linux` well" comment in buildFHSEnv.nix), and `.extend`
      # rebuilds the whole fixed point instead of overriding a single
      # derivation. That drops the splice, so every package pulled from this
      # set below (not just the ones touching `libpng`) ends up rebuilt from an
      # independent, non-spliced i686 bootstrap instead of sharing store paths
      # with the rest of the closure.
      freetype = pkgs.freetype.override { libpng = libpng12; };
      fontconfig = pkgs.fontconfig.override { inherit freetype; };
      libxft = pkgs.libxft.override { inherit freetype fontconfig; };
    in
    [
      # questa requirements
      libxml2
      ncurses5
      unixodbc
      libxft
      # common requirements
      freetype
      fontconfig
      libx11
      libxext
      libxrender
      libxcrypt-legacy
    ];

  # See above NOTE regarding libpng
  disallowedReferences = [
    pkgsi686Linux.libpng
  ];

  extraInstallCommands = ''
    mkdir -p $out/share/applications $out/share/icons/hicolor/64x64/apps
    ln -s ${desktopItem}/share/applications/* $out/share/applications
    ln -s ${unwrapped}/quartus/adm/quartusii.png $out/share/icons/hicolor/64x64/apps/quartus.png

    progs_to_wrap=(
      "${unwrapped}"/quartus/bin/*
      "${unwrapped}"/niosv/bin/*
      "${unwrapped}"/quartus/sopc_builder/bin/qsys-{generate,edit,script}
      "${unwrapped}"/questa_fse/bin/*
      "${unwrapped}"/questa_fse/linux_x86_64/lmutil
    )

    wrapper=$out/bin/quartus-prime-lite
    progs_wrapped=()
    for prog in ''${progs_to_wrap[@]}; do
        relname="''${prog#"${unwrapped}/"}"
        bname="$(basename "$relname")"
        wrapped="$out/$relname"
        progs_wrapped+=("$wrapped")
        mkdir -p "$(dirname "$wrapped")"
        echo "#!${runtimeShell}" >> "$wrapped"
        NIXPKGS_QUARTUS_THIS_PROG_SUPPORTS_FIXED_CLOCK=1
        case "$relname" in
            questa_fse/*)
                echo "export NIXPKGS_IS_QUESTA_WRAPPER=1" >> "$wrapped"
                # Any use of LD_PRELOAD breaks Questa, so disable the
                # SOURCE_DATE_EPOCH code path.
                NIXPKGS_QUARTUS_THIS_PROG_SUPPORTS_FIXED_CLOCK=0
                ;;
            niosv/*)
                # Both are needed for a functional niosv-bsp and possibly other
                # executables.
                echo "export QUARTUS_ROOTDIR=${unwrapped}/quartus" >> "$wrapped"
                echo "export SOPC_KIT_NIOS2=${unwrapped}/niosv" >> "$wrapped"
                ;;
        esac
        # SOURCE_DATE_EPOCH blocklist for programs that are known to hang/break
        # with fixed/static clock.
        case "$bname" in
            jtagd|quartus_pgm|quartus)
                NIXPKGS_QUARTUS_THIS_PROG_SUPPORTS_FIXED_CLOCK=0
                ;;
        esac
        echo "export NIXPKGS_QUARTUS_THIS_PROG_SUPPORTS_FIXED_CLOCK=$NIXPKGS_QUARTUS_THIS_PROG_SUPPORTS_FIXED_CLOCK" >> "$wrapped"
        # If a Wayland user has QT_QPA_PLATFORM=wayland, Quartus executables
        # that use Qt won't work, so let's be explicit.
        echo "export QT_QPA_PLATFORM=xcb" >> "$wrapped"
        # See above NOTE regarding `xdgOpenWrapper`
        echo "export PATH=${xdgOpenWrapper}/bin:\$PATH" >> "$wrapped"
        echo "exec $wrapper $prog \"\$@\"" >> "$wrapped"
    done

    cd $out
    chmod +x ''${progs_wrapped[@]}
    # link into $out/bin so executables become available on $PATH
    ln --symbolic --relative --target-directory ./bin ''${progs_wrapped[@]}
  '';

  profile = ''
    # LD_PRELOAD fixes issues in the licensing system that cause memory corruption and crashes when
    # starting most operations in many containerized environments, including WSL2, Docker, and LXC
    # (a similiar fix involving LD_PRELOADing tcmalloc did not solve the issue in my situation)
    # https://community.intel.com/t5/Intel-FPGA-Software-Installation/Running-Quartus-Prime-Standard-on-WSL-crashes-in-libudev-so/m-p/1189032
    #
    # But, as can be seen in the above resource, LD_PRELOADing libudev breaks
    # compiling encrypted device libraries in Questa (with error
    # `(vlog-2163) Macro `<protected> is undefined.`), so only use LD_PRELOAD
    # for non-Questa wrappers.
    if [ "$NIXPKGS_IS_QUESTA_WRAPPER" != 1 ]; then
        export LD_PRELOAD=''${LD_PRELOAD:+$LD_PRELOAD:}/usr/lib/libudev.so.0
    fi

    # Implement the SOURCE_DATE_EPOCH specification for reproducible builds
    # (https://reproducible-builds.org/specs/source-date-epoch).
    # Require opt-in with NIXPKGS_QUARTUS_REPRODUCIBLE_BUILD=1 for now, in case
    # the blocklist is incomplete.
    if [ -n "$SOURCE_DATE_EPOCH" ] && [ "$NIXPKGS_QUARTUS_REPRODUCIBLE_BUILD" = 1 ] && [ "$NIXPKGS_QUARTUS_THIS_PROG_SUPPORTS_FIXED_CLOCK" = 1 ]; then
        export LD_LIBRARY_PATH="${
          lib.makeLibraryPath [
            libfaketime
            pkgsi686Linux.libfaketime
          ]
        }''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
        export LD_PRELOAD=libfaketime.so.1''${LD_PRELOAD:+:$LD_PRELOAD}
        export FAKETIME_FMT="%s"
        export FAKETIME="$SOURCE_DATE_EPOCH"
    fi
  ''
  + extraProfile;

  # Run the wrappers directly, instead of going via bash.
  runScript = "";

  passthru = {
    inherit unwrapped;
    tests = {
      buildSof =
        runCommand "quartus-prime-lite-test-build-sof"
          {
            nativeBuildInputs = [ finalAttrs.finalPackage ];
            env.NIXPKGS_QUARTUS_REPRODUCIBLE_BUILD = "1";
          }
          ''
            cat >mydesign.vhd <<EOF
            library ieee;
            use ieee.std_logic_1164.all;

            entity mydesign is
            port (
                in_0: in std_logic;
                in_1: in std_logic;
                out_1: out std_logic
            );
            end mydesign;

            architecture dataflow of mydesign is
            begin
                out_1 <= in_0 and in_1;
            end dataflow;
            EOF

            quartus_sh --flow compile mydesign

            if ! [ -f mydesign.sof ]; then
                echo "error: failed to produce mydesign.sof" >&2
                exit 1
            fi

            sha1sum mydesign.sof > "$out"
          '';
      questaEncryptedModel =
        runCommand "quartus-prime-lite-test-questa-encrypted-model"
          {
            env.NIXPKGS_QUARTUS_REPRODUCIBLE_BUILD = "1";
          }
          ''
            "${finalAttrs.finalPackage}/bin/vlog" "${finalAttrs.passthru.unwrapped}/questa_fse/intel/verilog/src/arriav_atoms_ncrypt.v"
            touch "$out"
          '';
    };
  };

  inherit (unwrapped) meta;
})
