{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  glib,
  gtk4,
}:

rustPlatform.buildRustPackage rec {
  pname = "gnvim-unwrapped";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "vhakulinen";
    repo = "gnvim";
    rev = "v${version}";
    hash = "sha256-VyyHlyMW/9zYECobQwngFARQYqcoXmopyCHUwHolXfo=";
  };

  cargoHash = "sha256-+i4fFiuNmc2+aFyOW2FxRZXINN1XF0nDJVsFYnIHI24=";

  nativeBuildInputs = [
    pkg-config
    # for the `glib-compile-resources` command
    glib
  ];
  buildInputs = [
    glib
    gtk4
  ];

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
    mainProgram = "gnvim";
    homepage = "https://github.com/vhakulinen/gnvim";
    license = licenses.mit;
    maintainers = with maintainers; [ minijackson ];
  };
}
