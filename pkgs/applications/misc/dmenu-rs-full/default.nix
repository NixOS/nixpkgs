{ stdenv
, rustPlatform
, lib
, fetchFromGitHub
, aspell
, cargo
, expat
, fontconfig
, libXft
, libXinerama
, m4
, pkg-config
, python3
, xclip
, xdg-utils
}:

# This version of the dmenu-rs package is built with all the plugins that have
# been checked into the upstream repository. If you'd like to further
# customize dmenu-rs, either disabling specific plugins or enabling additional
# plugins from outside of the dmenu-rs repository, you'll have to build it
# from the source.
# See: https://github.com/Shizcow/dmenu-rs#plugins
stdenv.mkDerivation rec {
  pname = "dmenu-rs";
  version = "5.5.3";

  src = fetchFromGitHub {
    owner = "Shizcow";
    repo = "dmenu-rs";
    rev = version;
    hash = "sha256-05Ia+GHeL8PzOwR7H+NEVhKJVMPhlIaQLwGfvwOAl0g=";
  };

  nativeBuildInputs = [
    cargo
    m4
    pkg-config
    python3
    rustPlatform.bindgenHook
    rustPlatform.cargoSetupHook
  ];

  buildInputs = [
    aspell
    expat
    fontconfig
    libXft
    libXinerama
    xclip
    xdg-utils
  ];

  # The dmenu-rs repository does not include a Cargo.lock because of its
  # dynamic build and plugin support. Generating it with make and checking it
  # in to nixpkgs here was the easiest way to supply it to rustPlatform.
  # See: https://github.com/Shizcow/dmenu-rs/issues/34#issuecomment-757415584
  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
  };

  # Copy the Cargo.lock stored here in nixpkgs into the build directory.
  # TODO why do we need the chmod +w now? Note, it's required for make to write to the cargo ... maybe we can get around this somehow
  postPatch = ''
    cp ${./Cargo.lock} src/Cargo.lock
    chmod +w src/Cargo.lock
  '';

  # Configures the build to include all plugins in the dmenu-rs repository.
  preBuild = ''
    sed -i -E "s/PLUGINS =/PLUGINS = $(find src/plugins/ -mindepth 1 -maxdepth 1 -type d -printf "%f\n" | tr "\n" " ")/" config.mk
  '';

  cargoRoot = "src";

  installFlags = [ "PREFIX=$(out)" ];

  # Running make test requires an X11 server. It also runs dmenu, which then
  # hangs on user input. It was too hard to figure out how to run these tests
  # deterministically. See the original PR for some discussion on this.
  doCheck = false;

  meta = with lib; {
    description = "A pixel perfect port of dmenu, rewritten in Rust with extensive plugin support (plugins enabled)";
    homepage = "https://github.com/Shizcow/dmenu-rs";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ benjaminedwardwebb ];
    platforms = platforms.linux;
    broken = (stdenv.isLinux && stdenv.isAarch64);
  };
}
