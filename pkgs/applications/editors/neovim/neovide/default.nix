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
, vulkan-loader
, fontconfig
, ninja
, gn
, llvmPackages
, makeFontsConf
}:
rustPlatform.buildRustPackage rec {
  pname = "neovide";
  version = "20210515";

  src =
    let
      repo = fetchFromGitHub {
        owner = "Kethku";
        repo = "neovide";
        rev = "0b976c3d28bbd24e6c83a2efc077aa96dde1e9eb";
        sha256 = "sha256-asaOxcAenKdy/yJvch3HFfgnrBnQagL02UpWYnz7sa8=";
      };
    in
    runCommand "source" { } ''
      cp -R ${repo} $out
      chmod -R +w $out
      # Reasons for patching Cargo.toml:
      # - I got neovide built with latest compatible skia-save version 0.35.1
      #   and I did not try to get it with 0.32.1 working. Changing the skia
      #   version is time consuming, because of manual dependecy tracking and
      #   long compilation runs.
      sed -i $out/Cargo.toml \
        -e '/skia-safe/s;0.32.1;0.35.1;'
      cp ${./Cargo.lock} $out/Cargo.lock
    '';

  cargoSha256 = "sha256-XMPRM3BAfCleS0LXQv03A3lQhlUhAP8/9PdVbAUnfG0=";

  SKIA_OFFLINE_SOURCE_DIR =
    let
      repo = fetchFromGitHub {
        owner = "rust-skia";
        repo = "skia";
        # see rust-skia/Cargo.toml#package.metadata skia
        rev = "m86-0.35.0";
        sha256 = "sha256-uTSgtiEkbE9e08zYOkRZyiHkwOLr/FbBYkr2d+NZ8J0=";
      };
      # The externals for skia are taken from skia/DEPS
      externals = lib.mapAttrs (n: v: fetchgit v) (lib.importJSON ./skia-externals.json);
    in
    runCommand "source" { } (''
      cp -R ${repo} $out
      chmod -R +w $out

      mkdir -p $out/third_party/externals
      cd $out/third_party/externals
    '' + (builtins.concatStringsSep "\n" (lib.mapAttrsToList (name: value: "cp -ra ${value} ${name}") externals)));

  SKIA_OFFLINE_NINJA_COMMAND = "${ninja}/bin/ninja";
  SKIA_OFFLINE_GN_COMMAND = "${gn}/bin/gn";
  LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";

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
      --prefix LD_LIBRARY_PATH : ${vulkan-loader}/lib
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
