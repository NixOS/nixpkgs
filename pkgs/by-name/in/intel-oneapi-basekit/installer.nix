{
  buildFHSEnv,
  stdenv,
  lib,
  writeShellScript,
  fetchurl,
  autoPatchelfHook,

  config,
  cudaSupport ? config.cudaSupport,
  cudaPackages,
  autoAddDriverRunpath,

  # Core dependencies
  level-zero,
  zlib,
  gcc,

  # MPI dependencies
  rdma-core,
  numactl,
  libpsm2,
  ucx,
  libuuid,

  # UI dependencies
  alsa-lib,
  at-spi2-atk,
  bzip2,
  cairo,
  libxcrypt-legacy,
  cups, # .lib
  dbus, # .lib
  libdrm,
  expat,
  libffi_3_2_1,
  libgbm,
  gdbm_1_13,
  glib,
  ncurses5,
  nspr,
  nss,
  pango,
  sqlite,
  systemd, # For libudev
  # libuuid,
  xorg, # .libX11, .libxcb, .libXcomposite, .libXdamage, .libXext, .libXfixes, .libXrandr
  libxkbcommon,

  # Advisor-only dependencies
  fontconfig,
  freetype,
  gdk-pixbuf,
  gtk2,
  # xorg.libXxf86vm

  # VTune-only dependencies
  elfutils,
  gtk3,
  libnotify,
  opencl-clang_14,
  xdg-utils,
}:
let
  makeKit =
    {
      # "base" or "hpc"
      kit,
      version,
      uuid,
      sha256,
    }:
    let
      withComponents =
        # The components to install
        # Note that because the offline installer is used, all components will still
        # be downloaded, however only the selected components will be installed.
        # Options:
        # "all", "default", or ["foo", "bar", ...], ["default", "foo", ...] where foo, bar
        # are components of the Intel OneAPI HPC Toolkit like:
        #  intel.oneapi.lin.dpcpp-cpp-compiler
        #  intel.oneapi.lin.dpl
        #  intel.oneapi.lin.vtune
        #  ...
        # or "list", which is a utility that makes the installer list the available components
        # and exit with a non-zero status code, so that you can see the available components
        # without running the installer yourself
        components:
        let
          components_all = components == "all";
          components_default =
            components == "default" || (lib.isList components && lib.elem "default" components);
          components_string =
            if lib.isString components then
              if components_all || components_default || components == "list" then
                components
              else
                throw "Invalid string for Intel oneAPI components specification. Expected 'all', 'default' or 'list', but got \"${components}\"."
            else if lib.isList components then
              if lib.all lib.isString components then
                if lib.elem "default" components then
                  let
                    # "default" is a special-case, and the final string should start with it
                    otherComponents = lib.filter (c: c != "default") components;
                    orderedComponents = [ "default" ] ++ otherComponents;
                  in
                  lib.concatStringsSep ":" orderedComponents
                else
                  lib.concatStringsSep ":" components
              else
                throw "Invalid list for oneAPI components specification. The list must only contain strings representing component names."
            else
              throw "Invalid type for oneAPI components specification. Expected a string ('all', 'default' or 'list') or a list of component names, but got a ${lib.typeOf components}.";
          components_used =
            let
              all_or_default = components_all || components_default;
              has_component = c: lib.isList components && lib.elem c components;
            in
            {
              # Even though it's not listed on the download page, both the Base and HPC kit include MPI.
              mpi = all_or_default || has_component "intel.oneapi.lin.mpi.devel";
              vtune = all_or_default || has_component "intel.oneapi.lin.vtune";
              advisor = all_or_default || has_component "intel.oneapi.lin.advisor";
              ui = components_used.vtune || components_used.advisor;
            };
        in
        stdenv.mkDerivation (finalAttrs: {
          pname = "intel-oneapi-${kit}kit";
          inherit version;

          src = fetchurl {
            url = "https://registrationcenter-download.intel.com/akdlm/IRC_NAS/${uuid}/intel-oneapi-${kit}-toolkit-${version}_offline.sh";
            inherit sha256;
          };

          unpackPhase = ''
            runHook preUnpack

            sh $src \
              --extract-only --extract-folder . \
              --remove-extracted-files no --log ./extract.log

            runHook postUnpack
          '';

          nativeBuildInputs =
            [ autoPatchelfHook ]
            ++ lib.optionals cudaSupport [
              autoAddDriverRunpath
              cudaPackages.cuda_nvcc
              (lib.getDev cudaPackages.cuda_cudart)
            ];

          buildInputs =
            [
              level-zero
              zlib
              gcc
            ]
            ++ lib.optionals components_used.mpi [
              rdma-core
              numactl
              libpsm2
              ucx
              libuuid
            ]
            ++ lib.optionals components_used.ui [
              alsa-lib
              at-spi2-atk
              bzip2
              cairo
              libxcrypt-legacy
              cups.lib
              dbus.lib
              libdrm
              expat
              libffi_3_2_1
              libgbm
              gdbm_1_13
              glib
              ncurses5
              nspr
              nss
              pango
              sqlite
              systemd # For libudev
              libuuid
              xorg.libX11
              xorg.libxcb
              xorg.libXcomposite
              xorg.libXdamage
              xorg.libXext
              xorg.libXfixes
              xorg.libXrandr
              libxkbcommon
            ]
            ++ lib.optionals components_used.vtune [
              elfutils
              gtk3
              libnotify
              opencl-clang_14
              xdg-utils
            ]
            ++ lib.optionals components_used.advisor [
              fontconfig
              freetype
              gdk-pixbuf
              gtk2
              xorg.libXxf86vm
            ];

          installPhase =
            let
              # The installer will try to act as root if we don't wrap it like this.
              # I could not get it to run using just fakeroot.
              fhs = buildFHSEnv {
                name = "oneapi-installer-fhs-env";

                targetPkgs =
                  pkgs:
                  (with pkgs; [
                    patchelf
                    stdenv.cc.cc.lib
                  ]);

                nativeBuildInputs = [
                  autoPatchelfHook
                ];

                # The installer also links to qt6 and other libraries,
                # but these are only used for the GUI.
                # Notably, these are vendored in $src/lib.
                # The installer runs fine with just the C++ standard library however.
                buildInputs = [
                  stdenv.cc.cc.lib
                ];

                # This allows the installer to actually write to the $out directory.
                # Otherwise you'd get permission denied errors.
                extraBwrapArgs = [
                  "--bind"
                  "$out"
                  "$out"
                ];
              };

              install = writeShellScript "intel-oneapi-installer" ''
                cd intel-oneapi-${kit}-toolkit-${version}_offline

                patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
                  ./bootstrapper

                if [ "$COMPONENTS" = "list" ]; then
                  echo "Available components:"
                  ./install.sh --list-components
                  exit 1
                fi

                echo "Installing the following components: $COMPONENTS"

                mkdir log
                exec sh ./install.sh \
                  --silent \
                  --eula accept \
                  --components "$COMPONENTS" \
                  --log-dir ./log \
                  --ignore-errors \
                  --install-dir $out \
              '';
            in
            ''
              runHook preInstall

              export COMPONENTS=${components_string}
              mkdir -p $out
              ${fhs}/bin/oneapi-installer-fhs-env -- ${install}

              runHook postInstall
            '';

          passthru = {
            updateScript = writeShellScript "update-intel-oneapi-${kit}kit" ''${./update.sh} ${kit}'';
            inherit makeKit withComponents;
          };

          autoPatchelfIgnoreMissingDeps = [
            "libcuda.so.1"
          ];

          # When not installing all components there will be broken symlinks for each skipped component like this:
          #   $out/opt/intel/oneapi/.toolkit_linking_tool/.envs/2025.2/oneapi-${kit}-toolkit/<uninstalled-component>
          dontCheckForBrokenSymlinks = true;

          meta =
            {
              license = lib.licenses.unfree;
              platforms = lib.platforms.linux;
              maintainers = [ lib.maintainers.blenderfreaky ];
            }
            // (
              let
                year = lib.versions.major version;
              in
              if kit == "base" then
                {
                  description = "Intel OneAPI Base Toolkit";
                  homepage = "https://www.intel.com/content/www/us/en/developer/tools/oneapi/base-toolkit.html";
                  changelog = "https://www.intel.com/content/www/us/en/developer/articles/release-notes/oneapi-base-toolkit/${year}.html";
                }
              else if kit == "hpc" then
                {
                  description = "Intel oneAPI HPC Toolkit";
                  homepage = "https://www.intel.com/content/www/us/en/developer/tools/oneapi/hpc-toolkit.html";
                  changelog = "https://www.intel.com/content/www/us/en/developer/articles/release-notes/oneapi-hpc-toolkit/${year}.html";
                }
              else
                throw "kit must be either 'base' or 'hpc'"
            );
        });
    in
    # By default we install all components
    withComponents "all";
in
makeKit
