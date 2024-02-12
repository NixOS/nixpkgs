{ stdenv
, rustPlatform
, lib
, fetchFromGitHub
, fetchpatch
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
  version = "5.5.2";

  src = fetchFromGitHub {
    owner = "Shizcow";
    repo = pname;
    rev = version;
    sha256 = "sha256-6yO2S6j/BD6x/bsuTFKAKvARl1n94KRiPwpmswmUOPU=";
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

  # Fix a bug in the makefile when installing.
  # See https://github.com/Shizcow/dmenu-rs/pull/50
  patches = let
    fix-broken-make-install-patch = fetchpatch {
      url = "https://github.com/Shizcow/dmenu-rs/commit/1f4b3f8a07d73272f8c6f19bfb6ff3de5e042815.patch";
      sha256 = "sha256-hmXApWg8qngc1vHkHUnB7Lt7wQUOyCSsBmn4HC1j53M=";
    };
  in [
    fix-broken-make-install-patch
  ];

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
    description = "A pixel perfect port of dmenu, rewritten in Rust with extensive plugin support";
    homepage = "https://github.com/Shizcow/dmenu-rs";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ benjaminedwardwebb ];
    platforms = platforms.linux;
    broken = (stdenv.isLinux && stdenv.isAarch64);
  };
}
