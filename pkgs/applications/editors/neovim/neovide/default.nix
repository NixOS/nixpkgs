{ rustPlatform
, runCommand
, lib
, fetchFromGitHub
, fetchgit
, fetchurl
, makeWrapper
, pkg-config
, python2
, python3
, openssl
, SDL2
, fontconfig
, freetype
, ninja
, gn
, llvmPackages
, makeFontsConf
, libglvnd
, libxkbcommon
, stdenv
, enableWayland ? stdenv.isLinux
, wayland
, xorg
}:
rustPlatform.buildRustPackage rec {
  pname = "neovide";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "Kethku";
    repo = "neovide";
    rev = version;
    sha256 = "sha256-PViSiK6+H79MLIOFe26cNqUZ6gZdqDC/S+ksTrbOm54=";
  };

  cargoSha256 = "sha256-GvueDUY4Hzfih/MyEfhdz/QNVd9atTC8SCF+PyuJJic=";

  SKIA_SOURCE_DIR =
    let
      repo = fetchFromGitHub {
        owner = "rust-skia";
        repo = "skia";
        # see rust-skia:skia-bindings/Cargo.toml#package.metadata skia
        rev = "m103-0.51.1";
        sha256 = "sha256-w5dw/lGm40gKkHPR1ji/L82Oa808Kuh8qaCeiqBLkLw=";
      };
      # The externals for skia are taken from skia/DEPS
      externals = lib.mapAttrs (n: fetchgit) (lib.importJSON ./skia-externals.json);
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
    python3 # rust-xcb
    llvmPackages.clang # skia
  ];

  # All tests passes but at the end cargo prints for unknown reason:
  #   error: test failed, to rerun pass '--bin neovide'
  # Increasing the loglevel did not help. In a nix-shell environment
  # the failure do not occure.
  doCheck = false;

  buildInputs = [
    openssl
    SDL2
    (fontconfig.overrideAttrs (old: {
      propagatedBuildInputs = [
        # skia is not compatible with freetype 2.11.0
        (freetype.overrideAttrs (old: rec {
          version = "2.10.4";
          src = fetchurl {
            url = "mirror://savannah/${old.pname}/${old.pname}-${version}.tar.xz";
            sha256 = "112pyy215chg7f7fmp2l9374chhhpihbh8wgpj5nj6avj3c59a46";
          };
        }))
      ];
    }))
  ];

  postFixup = let
    libPath = lib.makeLibraryPath ([
      libglvnd
      libxkbcommon
      xorg.libXcursor
      xorg.libXext
      xorg.libXrandr
      xorg.libXi
    ] ++ lib.optionals enableWayland [ wayland ]);
  in ''
      wrapProgram $out/bin/neovide \
        --prefix LD_LIBRARY_PATH : ${libPath}
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
    mainProgram = "neovide";
  };
}
