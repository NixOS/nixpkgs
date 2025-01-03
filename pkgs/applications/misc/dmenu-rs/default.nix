{ stdenv
, rustPlatform
, lib
, fetchFromGitHub
, cargo
, expat
, fontconfig
, libXft
, libXinerama
, m4
, pkg-config
, python3
}:

# The dmenu-rs package has extensive plugin support. However, this derivation
# only builds the package with the default set of plugins. If you'd like to
# further customize dmenu-rs you can build it from the source.
# See: https://github.com/Shizcow/dmenu-rs#plugins
stdenv.mkDerivation rec {
  pname = "dmenu-rs";
  version = "5.5.4";

  src = fetchFromGitHub {
    owner = "Shizcow";
    repo = "dmenu-rs";
    rev = version;
    hash = "sha256-LdbTvuq1IbzWEoASscIh3j3VAHm+W3UekJNiMHTxSQI=";
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

  meta = with lib; {
    description = "Pixel perfect port of dmenu, rewritten in Rust with extensive plugin support";
    homepage = "https://github.com/Shizcow/dmenu-rs";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ benjaminedwardwebb ];
    platforms = platforms.linux;
    broken = (stdenv.isLinux && stdenv.isAarch64);
  };
}
