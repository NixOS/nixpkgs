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
    zlib
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    xorg.libSM
    xorg.libICE
    xorg.libX11
    xorg.libXau
    xorg.libXi
    xorg.libXrender
    libselinux
    libGL
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
  version = "25.5.1-1";

  src =
    let
      selectSystem =
        attrs:
        attrs.${stdenv.hostPlatform.system}
          or (throw "conda: ${stdenv.hostPlatform.system} is not supported");
      arch = selectSystem {
        x86_64-linux = "x86_64";
        aarch64-linux = "aarch64";
        x86_64-darwin = "x86_64";
        aarch64-darwin = "arm64";
      };
      osName = selectSystem {
        x86_64-linux = "Linux";
        aarch64-linux = "Linux";
        x86_64-darwin = "MacOSX";
        aarch64-darwin = "MacOSX";
      };
    in
    fetchurl {
      url = "https://repo.anaconda.com/miniconda/Miniconda3-py313_${version}-${osName}-${arch}.sh";
      hash = selectSystem {
        x86_64-linux = "sha256-YSrxE7SdsDaOK+QaxNUbcIjuvV8x2u64nyP/+Pkg21g=";
        aarch64-linux = "sha256-t9YR3Kpjjv1wCkpOsk+8ufe5TMF3PXxlWVnDMNC2jhY=";
        x86_64-darwin = "sha256-QVLyYAQNRSv+AMZ6xrQprsf/O5j2K6uKvkxGjpjlGJE=";
        aarch64-darwin = "sha256-Lsb3mBdwszlqmrQm4HrI71sStDk6ouS8yYQ3b+OqMn4=";
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
    export NIX_CFLAGS_LINK="-L${installationPath}/lib"
    # Some other required environment variables
    ${lib.optionalString stdenv.hostPlatform.isLinux ''
      export FONTCONFIG_FILE=/etc/fonts/fonts.conf
      export QTCOMPOSE=${xorg.libX11}/share/X11/locale
    ''}
    export LIBARCHIVE=${lib.getLib libarchive}/lib/libarchive.${
      if stdenv.hostPlatform.isDarwin then "dylib" else "so"
    }
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
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    license = with lib.licenses; [ bsd3 ];
    maintainers = with lib.maintainers; [ jluttine ];
  };
}
