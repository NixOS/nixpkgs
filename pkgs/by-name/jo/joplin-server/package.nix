{
  lib,
  stdenv,
  dockerTools,
  gnutar,
  gzip,
  makeWrapper,
  jq,
  findutils,
  nodejs,
  coreutils,
}:

let
  version = "3.7.1";

  # Fetch official Joplin Server release layers
  image = dockerTools.pullImage {
    imageName = "joplin/server";
    imageDigest = "sha256:b9666df06e7e2db20aeb961d2aca19e20664b985ead96995ecd32f9d720f002c";
    sha256 = "sha256-zygt8eMwT43sMV7XU92A0LsonElqbOjQrt3DxItIsRI=";
    finalImageName = "joplin/server";
    finalImageTag = version;
  };

in
stdenv.mkDerivation {
  __structuredAttrs = true;
  pname = "joplin-server";
  inherit version;
  strictDeps = true;

  nativeBuildInputs = [
    gnutar
    gzip
    makeWrapper
    jq
    findutils
  ];

  buildCommand = ''
    mkdir -p $out/share/joplin-server
    mkdir -p tmp

    echo "Unpacking Joplin Server image manifest..."
    tar --no-same-owner --no-same-permissions -xf ${image} -C tmp

    echo "Extracting Joplin Server monorepo packages..."
    for layer in $(find tmp -maxdepth 2 -name '*.tar'); do
      tar --no-same-owner --no-same-permissions -xf "$layer" -C $out/share/joplin-server 'home/joplin/packages' 2>/dev/null || true
    done

    APP_DIR="$out/share/joplin-server/home/joplin/packages/server"

    if [ ! -d "$APP_DIR" ]; then
      echo "Error: Joplin Server app directory not found!"
      exit 1
    fi

    echo "Linking monorepo packages into node_modules/@joplin..."
    mkdir -p "$APP_DIR/node_modules/@joplin"
    for pkg in "$out/share/joplin-server/home/joplin/packages/"*; do
      pkg_name=$(basename "$pkg")
      if [ "$pkg_name" != "server" ]; then
        rm -rf "$APP_DIR/node_modules/@joplin/$pkg_name"
        ln -sf "$pkg" "$APP_DIR/node_modules/@joplin/$pkg_name"
      fi
    done

    # Symlink logs and temp directories to writable runtime paths
    ln -sf /tmp/joplin-server-logs "$APP_DIR/logs"
    ln -sf /tmp/joplin-server-temp "$APP_DIR/temp"

    echo "Found Joplin Server app at: $APP_DIR"

    # Create binary launcher wrapper targeting Node.js entry point (dist/app.js)
    mkdir -p $out/bin

    makeWrapper ${nodejs}/bin/node $out/bin/joplin-server \
      --run "mkdir -p /tmp/joplin-server-logs /tmp/joplin-server-temp" \
      --chdir "$APP_DIR" \
      --add-flags "$APP_DIR/dist/app.js" \
      --set NODE_ENV "production" \
      --prefix PATH : ${
        lib.makeBinPath [
          nodejs
          coreutils
        ]
      }
  '';

  meta = {
    description = "Joplin Synchronization Server";
    homepage = "https://joplinapp.org/";
    license = lib.licenses.unfreeRedistributable;
    maintainers = with lib.maintainers; [ Apollo-sudo767 ];
    mainProgram = "joplin-server";
    platforms = [ "x86_64-linux" ];
  };
}
