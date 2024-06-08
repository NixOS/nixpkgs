{
    alsa-lib,
    fetchFromGitHub,
    fontconfig,
    lib,
    libgit2,
    libxkbcommon,
    libz,
    makeWrapper,
    openssl,
    pkg-config,
    protobuf,
    rustPlatform,
    vulkan-loader,
    wayland,
    xorg
}:
rustPlatform.buildRustPackage (rec {

    pname = "zed";
    version = src.rev;
    src = fetchFromGitHub {
      owner = "zed-industries";
      repo = "zed";
      rev = "v0.139.3-pre";
      hash = "sha256-LJ4fsRaihc7dSiV9Q47QML6gNa8n9vniaYnuNrHZIH8=";
    };

    cargoLock = {
      lockFile = "${src.outPath}/Cargo.lock";
      outputHashes = {
        "alacritty_terminal-0.24.1-dev" = "sha256-aVB1CNOLjNh6AtvdbomODNrk00Md8yz8QzldzvDo1LI=";
        "async-pipe-0.1.3"              = "sha256-g120X88HGT8P6GNCrzpS5SutALx5H+45Sf4iSSxzctE=";
        "blade-graphics-0.4.0"          = "sha256-Lhzbpkaj8Ymj+BEVeR70USgXe50on+Tw6++6lAAvrTs=";
        "font-kit-0.11.0"               = "sha256-+4zMzjFyMS60HfLMEXGfXqKn6P+pOngLA45udV09DM8=";
        "lsp-types-0.95.1"              = "sha256-ZWgQH7sUkP51oni2rqYX8Fsme/bGQV1TL5SbmEAhATU=";
        "nvim-rs-0.6.0-pre"             = "sha256-bdWWuCsBv01mnPA5e5zRpq48BgOqaqIcAu+b7y1NnM8=";
        "pathfinder_simd-0.5.3"         = "sha256-bakBcAQZJdHQPXybe0zoMzE49aOHENQY7/ZWZUMt+pM=";
        "tree-sitter-0.20.100"          = "sha256-xZDWAjNIhWC2n39H7jJdKDgyE/J6+MAVSa8dHtZ6CLE=";
        "tree-sitter-go-0.20.0"         = "sha256-/mE21JSa3LWEiOgYPJcq0FYzTbBuNwp9JdZTZqmDIUU=";
        "tree-sitter-gowork-0.0.1"      = "sha256-lM4L4Ap/c8uCr4xUw9+l/vaGb3FxxnuZI0+xKYFDPVg=";
        "tree-sitter-heex-0.0.1"        = "sha256-6LREyZhdTDt3YHVRPDyqCaDXqcsPlHOoMFDb2B3+3xM=";
        "tree-sitter-jsdoc-0.20.0"      = "sha256-fKscFhgZ/BQnYnE5EwurFZgiE//O0WagRIHVtDyes/Y=";
        "tree-sitter-markdown-0.0.1"    = "sha256-F8VVd7yYa4nCrj/HEC13BTC7lkV3XSb2Z3BNi/VfSbs=";
        "tree-sitter-proto-0.0.2"       = "sha256-W0diP2ByAXYrc7Mu/sbqST6lgVIyHeSBmH7/y/X3NhU=";
        "xim-0.4.0"                     = "sha256-vxu3tjkzGeoRUj7vyP0vDGI7fweX8Drgy9hwOUOEQIA=";
      };
    };

    doCheck = false;

    # Needed to get openssl-sys to use pkgconfig.
    OPENSSL_NO_VENDOR = 1;

    nativeBuildInputs  = [ pkg-config protobuf makeWrapper ];

    postInstall = ''
      wrapProgram "$out/bin/zed" \
          --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [wayland vulkan-loader]}"
    '';

    buildInputs = [
        alsa-lib
        fontconfig
        libgit2
        openssl
        libxkbcommon
        libz
        pkg-config
        vulkan-loader
        wayland
        xorg.libxcb
    ];
  }
)
