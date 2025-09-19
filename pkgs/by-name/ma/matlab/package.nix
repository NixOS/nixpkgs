{
  lib,
  stdenvNoCC,
  buildFHSEnv,
  copyDesktopItems,
  libarchive,
  makeDesktopItem,
  writeShellScriptBin,

  fetchFromMPM,
  matlab-package-manager,
}:

stdenvNoCC.mkDerivation (self: {
  pname = "matlab";
  inherit (self.src) version;
  products = self.src.matlab-download.products or [ "MATLAB" ];

  matlabBins = [
    "matlab"
    "mex"
    "mlint"
  ];

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  src = fetchFromMPM {
    release = "R2024b";
    update = 1;
    extra-products = [ ];
    hash = "sha256-t7+vIk7254mo7dUaRFjZp/qHRpVWnIhy3OEoZfhwqUI=";
  };

  nativeBuildInputs = [ copyDesktopItems ];

  unwrapped =
    let
      unpack = lib.optionalAttrs (!(self.src ? "matlab-download")) {
        # Assume this is an ISO image from requireFile: unpack ISO contents
        nativeBuildInputs = [ libarchive ];
        unpackCmd = "bsdtar -vxf $curSrc -C iso";
      };
    in
    stdenvNoCC.mkDerivation (
      {
        pname = "matlab-unwrapped";
        inherit (self) src products version;

        __structuredAttrs = true;

        dontMakeSourcesWritable = true;
        dontConfigure = true;
        dontBuild = true;
        dontFixup = true;

        installPhase = ''
          # As mpm is bubblewrapped, it cannot write to $out directly
          # https://github.com/NixOS/nixpkgs/issues/239017
          dest="$(realpath ../install)"
          ${lib.getExe matlab-package-manager} install --source "$(pwd)" --destination "$dest" --products "''${products[@]}"
          mv $dest $out
          ln -s /etc/matlab $out/licenses
        '';
      }
      // unpack
    );

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/applications $out/share/pixmaps

    ln -s ${self.env}/bin/matlab-env $out/bin/matlab-env

    ${
      let
        launcherFor =
          name:
          writeShellScriptBin name ''
            for prefix in ${self.unwrapped}/bin ${self.unwrapped}/bin/glnxa64; do
              exe="$prefix/${name}"
              if [[ -f "$exe" ]]; then
                exec ${self.env}/bin/matlab-env "$exe" "''${@}"
              fi
            done

            echo "couldn't find MATLAB binary ${name}"
            exit 1
          '';
      in
      lib.concatMapStringsSep "\n" (name: ''
        if [ ! -f ${self.unwrapped}/bin/${name} ] && [ ! -f ${self.unwrapped}/bin/glnxa64/${name} ]; then
          echo "couldn't find MATLAB binary ${name}"
          exit 1
        fi
        ln -sv ${lib.getExe (launcherFor name)} $out/bin/${name}
      '') self.matlabBins
    }

    ln -s ${self.unwrapped}/bin/glnxa64/cef_resources/matlab_icon.png $out/share/pixmaps/matlab.png

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "matlab";
      exec = "matlab -desktop -useStartupFolderPref %F";
      comment = "MATLAB is a programming and numeric computing platform for engineering and scientific applications.";
      desktopName = "MATLAB ${self.matlab-download.release or self.version}";
      icon = "matlab";
      categories = [
        "Development"
        "Math"
        "Science"
      ];
      mimeTypes = [
        "text/x-matlab"
        "text/x-octave"
      ];
    })
  ];

  env = buildFHSEnv {
    name = "matlab-env";

    extraPreBwrapCmds = ''
      mkdir -p $HOME/.matlab/licenses

      # For some reason, MATLAB often fails to start unless this directory is cleared.
      # https://www.mathworks.com/matlabcentral/answers/1815365-how-do-i-uninstall-and-reinstall-the-mathworks-service-host
      rm -rf ~/.MathWorks/ServiceHost ~/.MATLABConnector
    '';

    extraBwrapArgs = [
      "--bind $HOME/.matlab/licenses /etc/matlab"
    ];

    targetPkgs =
      pkgs:
      builtins.attrValues {
        # From https://gitlab.com/doronbehar/nix-matlab/-/blob/master/common.nix
        inherit (pkgs)
          alsa-lib
          atk
          at-spi2-atk
          at-spi2-core
          cacert
          cairo
          cups
          dbus
          fontconfig
          gcc
          gdk-pixbuf
          gfortran
          git
          glib
          glibc
          glibcLocales
          gtk2
          gtk3
          jre
          libdrm
          libglvnd
          libselinux
          libsndfile
          libuuid
          libxcrypt
          libxcrypt-legacy
          libxkbcommon
          mesa
          ncurses
          nspr
          nss
          pam
          pango
          procps
          python3
          udev
          unzip
          xkeyboard_config
          zlib
          ;

        inherit (pkgs.gst_all_1)
          gst-plugins-base
          gstreamer
          ;

        inherit (pkgs.mesa)
          drivers
          ;

        inherit (pkgs.xorg)
          libSM
          libX11
          libXcomposite
          libXcursor
          libXdamage
          libXext
          libXfixes
          libXft
          libXi
          libXinerama
          libXrandr
          libXrender
          libXt
          libXtst
          libXxf86vm
          libxcb
          ;
      };

    runScript = lib.getExe (
      writeShellScriptBin "matlab-env" ''
        if [[ "$1" = "" ]]; then
          exec "$SHELL"
        else
          exec "''${@}"
        fi
      ''
    );
  };

  passthru.unwrapped = self.unwrapped;

  meta = {
    mainProgram = "matlab";
    description = "MATLAB is a programming and numeric computing platform for engineering and scientific applications.";
    homepage = "https://www.mathworks.com/products/matlab.html";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ james-atkins ];
  };
})
