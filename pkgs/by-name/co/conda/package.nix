{
  lib,
  stdenv,
  fetchurl,
  runCommand,
  makeWrapper,
  buildFHSEnv,
  libselinux,
  libarchive,
  libGL,
  xorg,
  zlib,
  # Conda installs its packages and environments under this directory
  installationPath ? "~/.conda",
  # Conda manages most pkgs itself, but expects a few to be on the system.
  condaDeps ? [
    stdenv.cc
    xorg.libSM
    xorg.libICE
    xorg.libX11
    xorg.libXau
    xorg.libXi
    xorg.libXrender
    libselinux
    libGL
    zlib
  ],
  # Any extra nixpkgs you'd like available in the FHS env for Conda to use
  extraPkgs ? [ ],
}:

# How to use this package?
#
# First-time setup: this nixpkg downloads the conda installer and provides a FHS
# env in which it can run. On first use, the user will need to install conda to
# the installPath using the installer:
# $ nix-env -iA conda
# $ conda-shell
# $ install-conda
#
# Under normal usage, simply call `conda-shell` to activate the FHS env,
# and then use conda commands as normal:
# $ conda-shell
# $ conda install spyder
let
  version = "25.1.1";

  src =
    let
      selectSystem =
        attrs:
        attrs.${stdenv.hostPlatform.system}
          or (throw "conda: ${stdenv.hostPlatform.system} is not supported");
      arch = selectSystem {
        x86_64-linux = "x86_64";
        aarch64-linux = "aarch64";
      };
    in
    fetchurl {
      url = "https://repo.anaconda.com/miniconda/Miniconda3-py312_${version}-0-Linux-${arch}.sh";
      hash = selectSystem {
        x86_64-linux = "sha256-gy3ielo1t5Y/DYNGarraPrE45RmFJV8ZDg3DUEJ6ndE=";
        aarch64-linux = "sha256-rp0+qD35fnj9UcRS0Lx1AFoo1QTCLbbxAAgiKT+Ra1Q=";
      };
    };

  conda = (
    let
      libPath = lib.makeLibraryPath [
        zlib # libz.so.1
      ];
    in
    runCommand "install-conda"
      {
        nativeBuildInputs = [ makeWrapper ];
        buildInputs = [ zlib ];
      }
      # on line 10, we have 'unset LD_LIBRARY_PATH'
      # we have to comment it out however in a way that the number of bytes in the
      # file does not change. So we replace the 'u' in the line with a '#'
      # The reason is that the binary payload is encoded as number
      # of bytes from the top of the installer script
      # and unsetting the library path prevents the zlib library from being discovered
      ''
        mkdir -p $out/bin

        sed 's/unset LD_LIBRARY_PATH/#nset LD_LIBRARY_PATH/' ${src} > $out/bin/miniconda-installer.sh
        chmod +x $out/bin/miniconda-installer.sh

        makeWrapper                            \
          $out/bin/miniconda-installer.sh      \
          $out/bin/install-conda               \
          --add-flags "-p ${installationPath}" \
          --add-flags "-b"                     \
          --prefix "LD_LIBRARY_PATH" : "${libPath}"
      ''
  );
in

buildFHSEnv {
  pname = "conda-shell";
  inherit version;

  targetPkgs =
    pkgs:
    (builtins.concatLists [
      [ conda ]
      condaDeps
      extraPkgs
    ]);

  profile = ''
    # Add conda to PATH
    export PATH=${installationPath}/bin:$PATH
    # Paths for gcc if compiling some C sources with pip
    export NIX_CFLAGS_COMPILE="-I${installationPath}/include"
    export NIX_CFLAGS_LINK="-L${installationPath}lib"
    # Some other required environment variables
    export FONTCONFIG_FILE=/etc/fonts/fonts.conf
    export QTCOMPOSE=${xorg.libX11}/share/X11/locale
    export LIBARCHIVE=${lib.getLib libarchive}/lib/libarchive.so
    # Allows `conda activate` to work properly
    condaSh=${installationPath}/etc/profile.d/conda.sh
    if [ ! -f $condaSh ]; then
      install-conda
    fi
    source $condaSh
  '';

  runScript = "bash -l";

  meta = {
    description = "Package manager for Python";
    mainProgram = "conda-shell";
    homepage = "https://conda.io";
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    license = with lib.licenses; [ bsd3 ];
    maintainers = with lib.maintainers; [ jluttine ];
  };
}
