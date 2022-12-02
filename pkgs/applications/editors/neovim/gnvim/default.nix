{ lib, rustPlatform, fetchFromGitHub, pkg-config, glib, gtk4 }:

rustPlatform.buildRustPackage rec {
  pname = "gnvim-unwrapped";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "vhakulinen";
    repo = "gnvim";
    rev = "v${version}";
    hash = "sha256-trTfDPMDL6k1/xkTteQDAGwxtmwFkuDD14MvTaedECU=";
  };

  cargoLock.lockFile = ./Cargo.lock;

  # glib is also a native build inputs for the `glib-compile-resources` command
  nativeBuildInputs = [ pkg-config glib ];
  buildInputs = [ glib gtk4 ];

  # The default build script tries to get the version through Git, so we
  # replace it
  postPatch = ''
    # Install the binary ourselves, since the Makefile doesn't have the path
    # containing the target architecture
    sed -e "/target\/release/d" -i Makefile
  '';

  postInstall = ''
    make install PREFIX="${placeholder "out"}"
  '';

  # GTK fails to initialize
  doCheck = false;

  meta = with lib; {
    description = "GUI for neovim, without any web bloat";
    homepage = "https://github.com/vhakulinen/gnvim";
    license = licenses.mit;
    maintainers = with maintainers; [ minijackson ];
  };
}
