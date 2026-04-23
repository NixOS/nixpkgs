# # {
# #   pkgs,
# #   lib,
# #   buildGoModule,
# #   fetchFromGitHub,
# #   stdenv,
# #   rustPlatform,
# #   nix-update-script,
# #   pnpm_9,
# #   nodejs_22,
# # }:

# # rustPlatform.buildRustPackage rec {
# #   pname = "hslink";
# #   version = "pre-release";

# #   src = fetchFromGitHub {
# #     owner = "HSLink";
# #     repo = "HSLinkUpper";
# #     rev = "d22bc42d17a72f0e4c586515c4e5a670bcf78d4c";
# #     hash = "sha256-drYlb2OgHj430CRkrMvEkBryuONp+M+tE24qBOyLgfI=";
# #   };

# #   sourceRoot = "${src.name}/src-tauri";

# #   useFetchCargoVendor = true;
# #   cargoHash = "sha256-yqNvVXER27OIgrZc9b0a/worOFIkEb3/CQpfguA7ltU=";
# #   cargoRoot = "src-tauri";


# #   nativeBuildInputs = [
# #     nodejs_22
# #     pnpm_9.configHook
# #     pkgs.pkg-config
# #     pkgs.gobject-introspection
# #     pkgs.cargo
# #     pkgs.cargo-tauri
# #     pkgs.rustc
# #     pkgs.rustup
# #     pkgs.openssl
# #     pkgs.gtk3
# #     pkgs.pkg-config
# #   ];

# #   buildInputs = [ 
# #     nodejs_22  
# #     pkgs.gtk3 
# #     pkgs.at-spi2-atk
# #     pkgs.atkmm
# #     pkgs.cairo
# #     pkgs.gdk-pixbuf
# #     pkgs.glib
# #     pkgs.gtk3
# #     pkgs.harfbuzz
# #     pkgs.librsvg
# #     pkgs.libsoup_3
# #     pkgs.pango
# #     pkgs.webkitgtk_4_1
# #     pkgs.openssl
# #     pkgs.libgudev
# #     pkgs.systemd
# #   ];


# #   pnpmDeps = pnpm_9.fetchDeps {
# #     inherit pname version src;
# #     hash = "sha256-sXmh8MxCp6E0kLVR2+vkEh7pKGlCfIrmPEsFrT/o4Gs=";

# #   };

# #   buildAndTestSubdir = cargoRoot;

# #   preConfigure = ''
# #     # pnpm.configHook has to write to .., as our sourceRoot is set to src-tauri
# #     # TODO: move frontend into its own drv
# #     export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath buildInputs}:$LD_LIBRARY_PATH"

# #     chmod +w -R ..
# #   '';·

# #   passthru = {
# #     inherit pnpmDeps;
# #     updateScript = nix-update-script { };
# #   };

# #   meta = with lib; {
# #     homepage = "https://github.com/HSLink/HSLinkUpper";
# #     description = "HSLinkUpper is a simple tool that allows you to config HSLink.";
# #     license = licenses.mit;
# #     platforms = platforms.all;
# #     mainProgram = "longcat";
# #     maintainers = with lib.maintainers; [
# #       bubblepipe
# #     ];
# #   };
# # }


# {
#   lib,
#   stdenv,
#   rustPlatform,
#   fetchNpmDeps,
#   cargo-tauri,
#   glib-networking,
#   nodejs,
#   pnpm,
#   openssl,
#   pkg-config,
#   webkitgtk_4_1,
#   wrapGAppsHook4,
#   fetchFromGitHub,
#   nix-update-script,
#   libgudev,
#   systemd,
#   autoPatchelfHook,
# }:

# rustPlatform.buildRustPackage rec {
#   # . . .

#   pname = "hs-link-upper";
#   version = "1.0.0";

#   src = fetchFromGitHub {
#     owner = "HSLink";
#     repo = "HSLinkUpper";
#     rev = "v${version}";
#     hash = "sha256-20w1KePFQgIuO446/kaQaXGlPq5Z7NP+dePiiBzepw8=";
#   };

#   useFetchCargoVendor = true;
#   cargoHash = "sha256-l2LtrOEg32Rw/PWSV0iqQIoYLW+U+mYI6McmjBu43tA=";
#   cargoRoot = "src-tauri";

#   #sourceRoot = "${src.name}/src-tauri";

#   pnpmDeps = pnpm.fetchDeps {
#     inherit pname version src;
#     hash = "sha256-j/trn3HeLDkiOPaMHCsYYvngWL3qBjF0nfe8THAvxuw=";
#     #      hash = "sha256-sXmh8MxCp6E0kLVR2+vkEh7pKGlCfIrmPEsFrT/o4Gs=";
#   };

#   nativeBuildInputs = [
#     # Pull in our main hook
#     cargo-tauri.hook

#     pnpm.configHook
#     # Setup npm
#     nodejs

#     # Make sure we can find our libraries
#     pkg-config
#     wrapGAppsHook4
#     autoPatchelfHook
#   ];

#   buildInputs =
#     [ openssl
#       nodejs
#     ]
#     ++ lib.optionals stdenv.hostPlatform.isLinux [
#       glib-networking # Most Tauri apps need networking
#       webkitgtk_4_1

#       libgudev
#       systemd
#     ];

#   # Set our Tauri source directory
#   # And make sure we build there too
#   buildAndTestSubdir = cargoRoot;

#   passthru = {
#     inherit pnpmDeps;
#     updateScript = nix-update-script { };
#   };

#   meta = with lib; {
#     homepage = "https://github.com/HSLink/HSLinkUpper";
#     description = "HSLinkUpper is a simple tool that allows you to config HSLink.";
#     license = licenses.mit;
#     platforms = platforms.all;
#     mainProgram = "longcat";
#     maintainers = with lib.maintainers; [
#       bubblepipe
#     ];
#   };
# }

# with import <nixpkgs> { };
{
  lib,
  stdenv,
  rustPlatform,
  fetchNpmDeps,
  cargo-tauri,
  glib-networking,
  nodejs,
  pnpm,
  openssl,
  pkg-config,
  webkitgtk_4_1,
  wrapGAppsHook4,
  fetchFromGitHub,
  nix-update-script,
  libgudev,
  systemd,
  autoPatchelfHook,
}:

rustPlatform.buildRustPackage rec {
  # . . .

  pname = "HSLinkNexus";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "HSLink";
    repo = "HSLinkNexus";
    rev = "v${version}";
    hash = "sha256-20w1KePFQgIuO446/kaQaXGlPq5Z7NP+dePiiBzepw8=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-l2LtrOEg32Rw/PWSV0iqQIoYLW+U+mYI6McmjBu43tA=";
  cargoRoot = "src-tauri";

  #sourceRoot = "${src.name}/src-tauri";

  pnpmDeps = pnpm.fetchDeps {
    inherit pname version src;
    hash = "sha256-j/trn3HeLDkiOPaMHCsYYvngWL3qBjF0nfe8THAvxuw=";
    #      hash = "sha256-sXmh8MxCp6E0kLVR2+vkEh7pKGlCfIrmPEsFrT/o4Gs=";
  };

  nativeBuildInputs = [
    # Pull in our main hook
    cargo-tauri.hook

    pnpm.configHook
    # Setup npm
    nodejs

    # Make sure we can find our libraries
    pkg-config
    wrapGAppsHook4
    autoPatchelfHook
  ];

  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      glib-networking # Most Tauri apps need networking
      webkitgtk_4_1

      libgudev
      systemd
    ];

  # Set our Tauri source directory
  # And make sure we build there too
  buildAndTestSubdir = cargoRoot;

  passthru = {
    inherit pnpmDeps;
    updateScript = nix-update-script { };
  };

  # . . .
}
