{
  lib,
  stdenv,

  buildPackages,
  fetchurl,
  fetchFromGitHub,
  fetchNpmDeps,
  rustPlatform,
  writeShellScriptBin,

  cmake,
  deno,
  gtk3,
  libxkbcommon,
  libGL,
  makeWrapper,
  nodejs,
  openssl,
  pkg-config,
  protobuf,
  wayland,
  xorg,
  yq,
}: let
  inherit (buildPackages.npmHooks.override {inherit nodejs;}) npmConfigHook;
  inherit (lib) concatStringsSep getExe' licenses maintainers makeBinPath makeLibraryPath optional sourceTypes;
  inherit (stdenv.hostPlatform) isLinux rust system;

  pname = "gauntlet";
  version = "12";
  src = fetchFromGitHub {
    owner = "project-gauntlet";
    repo = "gauntlet";
    rev = "refs/tags/v${version}";
    hash = "sha256-bvoOVKBl0c0q+XB8G5rxxu1X+sZ2bp4Pl90saYas9Zo=";
  };
  platforms = ["x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin"];

  buildRustyV8Url = version: target: "https://github.com/denoland/rusty_v8/releases/download/v${version}/librusty_v8_release_${target}.a.gz";
  fetchRustyV8 = version: hashes:
    fetchurl {
      name = "librusty_v8-${version}";
      url = buildRustyV8Url version rust.rustcTarget;
      hash = hashes.${system};
      meta.version = version;
      meta.sourceProvenance = [sourceTypes.binaryNativeCode];
    };
in rustPlatform.buildRustPackage {
  inherit pname src version;

  # Duplicate sources (dpi 0.1.1 from crates.io and git) must be merged while awaiting https://github.com/NixOS/nixpkgs/pull/282798
  # TODO why do neither of these strategies work as a workaround?!
  #
  # Workaround 1
  # cargoHash = "sha256-y9C0zAV2GmNQ02LYt8YWQYLRGNR/5s7nBrgHfr0rOfw=";
  # cargoPatches = [./duplicates.patch];
  # useFetchCargoVendor = true;
  #
  # Workaround 2
  # cargoLock.lockFile = ./Cargo.lock;
  # cargoLock.outputHashes = {
  #   "dpi-0.1.1" = "sha256-Skp6/taKxDAsdRs3ajI3lb+WGpJTqat+ZZ9gE7FUxd8=";
  #   "glyphon-0.5.0" = "sha256-VgeV/5nYQwzYQWN8/e/kCljqv3vB7McJb4aA6OhhrOI=";
  #   "iced-0.13.99" = "sha256-ReZBJfRDHal3g+0jlPIBFdW5wzQCntmQ2zWqt5jBEtQ=";
  #   "iced_aw-0.11.99" = "sha256-BVyHxj4H0r0MUCeMNzPTj2wBdnqatjyTOIGnPYbIZgg=";
  #   "iced_fonts-0.1.99" = "sha256-Foq/f/Qjjm58yE1QLukHXxnBUB0JBMiHj6wEZuwy+Bc=";
  #   "iced_layershell-0.13.99" = "sha256-+Rxe6+zeNT7hgir1OOhb+5fpdlXkoSQxIspEoGsZMBg=";
  #   "iced_table-0.13.99" = "sha256-37yrSysSUI3dr3bTTJ5RxRpsT92LYPyf8YFirQJyHq0=";
  #   "libffi-sys-2.3.0" = "sha256-EBVKSB2a7fJi7PkK85fcgzuvlWsxbTWIyiSmSl9l4J0=";
  # };
  buildFeatures = ["release"];
  OPENSSL_NO_VENDOR = true;
  RUSTY_V8_ARCHIVE = fetchRustyV8 "130.0.2" {
    aarch64-darwin = "sha256-aWZ/4Q4Wttx37xOdBmTCPGP+eYGhr4CM1UkYq8pC7Qs=";
    aarch64-linux = "sha256-p9+tHmKIM5wBABubHIAstpwfzO19ypPzOuaV4b6loCU=";
    x86_64-darwin = "sha256-zNC0DAkMbbFM1M+t6rgKtN0QAm4ONEbCi6Sxivhf8dk=";
    x86_64-linux = "sha256-ew2WZhdsHfffRQtif076AWAlFohwPo/RbmW/6D3LzkU=";
  };

  # fetchNpmDeps + makeCacheWritable are required with npm git:// dependencies
  makeCacheWritable = true;
  npmDeps = fetchNpmDeps {
    inherit src;
    name = "${pname}-${version}-npm-deps";
    hash = "sha256-TlfUwNsmyN4dzqBh3CW33pGXxBZHLhSDyAqS4fJCmPU=";
  };

  nativeBuildInputs = [cmake nodejs npmConfigHook pkg-config protobuf] ++ optional isLinux makeWrapper;
  buildInputs = [deno openssl] ++ optional isLinux libxkbcommon;
  preBuild = "npm run build";
  postInstall =
    if isLinux
    then ''
      install -Dm644 assets/linux/gauntlet.desktop $out/share/applications/gauntlet.desktop
      install -Dm644 assets/linux/gauntlet.service $out/lib/systemd/user/gauntlet.service
      install -Dm644 assets/linux/icon_256.png $out/share/icons/hicolor/256x256/apps/gauntlet.png
    ''
    else ''
      contentsDir=$out/Applications/Gauntlet.app/Contents
      install -Dm755 $out/bin/gauntlet $contentsDir/MacOS/Gauntlet
      install -Dm644 assets/macos/AppIcon.icns $contentsDir/Resources/AppIcon.icns
      install -Dm644 assets/macos/Info.plist $contentsDir/Info.plist
    '';
  postFixup =
    if isLinux
    then ''
      patchelf --add-rpath ${makeLibraryPath [libGL xorg.libX11 wayland]} $out/bin/gauntlet
      wrapProgram $out/bin/gauntlet --suffix PATH : ${makeBinPath [gtk3]}
      substituteInPlace $out/lib/systemd/user/gauntlet.service --replace /usr/bin/gauntlet $out/bin/gauntlet
    ''
    else ''
      substituteInPlace $out/Applications/Gauntlet.app/Contents/Info.plist --replace __VERSION__ ${version}
    '';

  # When v8 version changes, run fetchRustyV8Hashes to replace RUSTY_V8_ARCHIVE above
  passthru.fetchRustyV8Hashes = writeShellScriptBin "fetch-librusty_v8-hashes.sh" ''
    version=$(${getExe' yq "tomlq"} '.package | map(select(.name == "v8")) | .[0].version' --raw-output ${src}/Cargo.lock)
    echo "Update librusty as follows:"
    echo "RUSTY_V8_ARCHIVE = fetchRustyV8 \"$version\" {"
    for system in ${concatStringsSep " " platforms}; do
        target=$(nix eval --raw nixpkgs#legacyPackages.$system.stdenv.hostPlatform.rust.rustcTarget)
        hash=$(nix-prefetch-url --print-path ${buildRustyV8Url "$version" "$target"} | tail -n 1 | xargs nix hash file)
        echo "  $system = \"$hash\";"
    done
    echo "};"
  '';

  meta = {
    inherit platforms;
    description = "Raycast-inspired open-source cross-platform application launcher with React-based plugins";
    homepage = "https://github.com/project-gauntlet/gauntlet";
    license = licenses.mpl20;
    maintainers = [maintainers.schradert];
    mainProgram = "gauntlet";
  };
}
