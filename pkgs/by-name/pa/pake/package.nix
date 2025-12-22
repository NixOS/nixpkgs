{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  makeWrapper,
  webkitgtk_6_0,
  gtk3,
  libsoup_2_4,
  cairo,
  gdk-pixbuf,
  glib,
  openssl,
  dbus,
  nodejs,
}:

let
  pname = "pake";
  version = "3.2.16";
in
rustPlatform.buildRustPackage rec {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "tw93";
    repo = "Pake";
    rev = "V${version}";
    hash = "sha256-vPW8pWIg+8pYwrs0D0I9gC1mVJSfIel6VVtc5uS+q3c=";
  };

  cargoHash = "sha256-wicC8j8bMRLoe8bnUVP/hF9zgtimvvQefqOc130OPyA=";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
    nodejs
  ];

  buildInputs = [
    webkitgtk_6_0
    gtk3
    libsoup_2_4
    cairo
    gdk-pixbuf
    glib
    openssl
    dbus
  ];

  sourceRoot = "source";

  postPatch = ''
    # Copy Cargo.lock from src-tauri to source root for cargo vendoring
    cp src-tauri/Cargo.lock ./Cargo.lock
  '';

  preBuild = ''
    export HOME="$TMPDIR/home"
    mkdir -p "$HOME"

    # Run npm install with proper permissions
    if [ ! -f "package-lock.json" ]; then
      echo "Error: package-lock.json not found"
      echo "Current directory: $PWD"
      echo "Contents:"
      ls -la
      exit 1
    fi

    # Install npm dependencies
    npm ci

    cd src-tauri
  '';

  # Wrap the binary with required environment variables
  postInstall = ''
    wrapProgram $out/bin/pake \
      --prefix GIO_MODULE_DIR : "${glib.out}/lib/gio/modules" \
      --prefix GDK_PIXBUF_MODULE_FILE : "${gdk-pixbuf.out}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache" \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath buildInputs}
  '';

  meta = with lib; {
    description = "Turn any webpage into a desktop app with Rust";
    homepage = "https://github.com/tw93/Pake";
    license = licenses.mit;
    maintainers = with maintainers; [ repparw ];
    platforms = platforms.linux;
    mainProgram = "pake";
  };
}
