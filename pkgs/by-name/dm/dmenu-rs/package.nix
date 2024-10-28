{
  lib,
  stdenv,
  fetchFromGitHub,

  # nativeBuildInputs
  cargo,
  m4,
  pkg-config,
  python3,
  rustPlatform,

  # buildInputs
  expat,
  fontconfig,
  libXft,
  libXinerama,
}:

# The dmenu-rs package has extensive plugin support. However, only a variant
# of dmenu-rs without any plugins is packaged here. This is because the set of
# plugins is defined at compile time and the dmenu-rs build uses this set to
# dynamically generate a corresponding Cargo.lock file. To work around this
# dynamic generation in nixpkgs, the Cargo.lock file has been generated in
# advance and then checked in here. If you'd like to further customize
# dmenu-rs, either disabling specific plugins or enabling additional plugins,
# you'll have to build it from the source.
# See: https://github.com/Shizcow/dmenu-rs#plugins
stdenv.mkDerivation rec {
  pname = "dmenu-rs";
  version = "5.5.4";

  src = fetchFromGitHub {
    owner = "Shizcow";
    repo = "dmenu-rs";
    rev = "refs/tags/${version}";
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

  buildInputs =
    [
      expat
      fontconfig
      libXft
      libXinerama
    ];

  # The dmenu-rs repository does not include a Cargo.lock because of its
  # dynamic build and plugin support. Generating it with make and checking it
  # in to nixpkgs here was the easiest way to supply it to rustPlatform.
  # See: https://github.com/Shizcow/dmenu-rs/issues/34#issuecomment-757415584
  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
  };

  # Copy the Cargo.lock stored here in nixpkgs into the build directory.
  postPatch = ''
    cp ${./Cargo.lock} src/Cargo.lock
  '';

  cargoRoot = "src";

  installFlags = [ "PREFIX=$(out)" ];

  # Running make test requires an X11 server. It also runs dmenu, which then
  # hangs on user input. It was too hard to figure out how to run these tests
  # deterministically. See the original PR for some discussion on this.
  doCheck = false;

  meta = {
    description = "Pixel perfect port of dmenu, rewritten in Rust with extensive plugin support";
    homepage = "https://github.com/Shizcow/dmenu-rs";
    license = with lib.licenses; [ gpl3Only ];
    maintainers = with lib.maintainers; [ benjaminedwardwebb ];
    platforms = lib.platforms.linux;
    broken = stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64;
  };
}
