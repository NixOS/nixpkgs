{ rustPlatform
, runCommand
, lib
, fetchFromGitHub
, fetchgit
, makeWrapper
, pkg-config
, python2
, expat
, openssl
, SDL2
, fontconfig
, ninja
, gn
, llvmPackages
, makeFontsConf
, libglvnd
, xorg
}:
rustPlatform.buildRustPackage rec {
  pname = "neovide";
  version = "unstable-2021-06-18";

  src = fetchFromGitHub {
    owner = "Kethku";
    repo = "neovide";
    rev = "599dc5887d8799ae8971259bc3bdbaa7b6e2ef45";
    sha256 = "sha256-mwIJ9kI0N6W/3km8H6TdDfSO3TdLg+A/5DSxejRg3i8=";
  };

  cargoSha256 = "sha256-Fg2cDwjW6Ex5uUZ8226kgNd/6EoeJddp/rULqH70NRs=";

  SKIA_SOURCE_DIR =
    let
      repo = fetchFromGitHub {
        owner = "rust-skia";
        repo = "skia";
        # see rust-skia:skia-bindings/Cargo.toml#package.metadata skia
        rev = "m90-0.38.3";
        sha256 = "sha256-l8c4vfO1PELAT8bDyr/yQGZetZsaufAlJ6bBOXz7E1w=";
      };
      # The externals for skia are taken from skia/DEPS
      externals = lib.mapAttrs (n: v: fetchgit v) (lib.importJSON ./skia-externals.json);
    in
      runCommand "source" {} (
        ''
          cp -R ${repo} $out
          chmod -R +w $out

          mkdir -p $out/third_party/externals
          cd $out/third_party/externals
        '' + (builtins.concatStringsSep "\n" (lib.mapAttrsToList (name: value: "cp -ra ${value} ${name}") externals))
      );

  SKIA_NINJA_COMMAND = "${ninja}/bin/ninja";
  SKIA_GN_COMMAND = "${gn}/bin/gn";
  LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";

  preConfigure = ''
    unset CC CXX
  '';

  # test needs a valid fontconfig file
  FONTCONFIG_FILE = makeFontsConf { fontDirectories = [ ]; };

  nativeBuildInputs = [
    pkg-config
    makeWrapper
    python2 # skia-bindings
    llvmPackages.clang # skia
  ];

  # All tests passes but at the end cargo prints for unknown reason:
  #   error: test failed, to rerun pass '--bin neovide'
  # Increasing the loglevel did not help. In a nix-shell environment
  # the failure do not occure.
  doCheck = false;

  buildInputs = [
    expat
    openssl
    SDL2
    fontconfig
  ];

  postFixup = ''
      wrapProgram $out/bin/neovide \
        --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libglvnd xorg.libXcursor xorg.libXext xorg.libXrandr xorg.libXi ]}
    '';

  postInstall = ''
    for n in 16x16 32x32 48x48 256x256; do
      install -m444 -D "assets/neovide-$n.png" \
        "$out/share/icons/hicolor/$n/apps/neovide.png"
    done
    install -m444 -Dt $out/share/icons/hicolor/scalable/apps assets/neovide.svg
    install -m444 -Dt $out/share/applications assets/neovide.desktop
  '';

  meta = with lib; {
    description = "This is a simple graphical user interface for Neovim.";
    homepage = "https://github.com/Kethku/neovide";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ ck3d ];
    platforms = platforms.linux;
  };
}
