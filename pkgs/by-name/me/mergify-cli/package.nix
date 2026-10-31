{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
}:

let
  # Map Nix system strings to the target triples used in Mergify release assets
  target =
    if stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isx86_64 then
      "x86_64-unknown-linux-gnu"
    else if stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64 then
      "aarch64-unknown-linux-gnu"
    else if stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64 then
      "x86_64-apple-darwin"
    else if stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64 then
      "aarch64-apple-darwin"
    else
      throw "Unsupported system: ${stdenv.hostPlatform.system}";

  version = "2026.10.11";

  # Platform-specific source URLs and hashes
  sources = {
    "x86_64-unknown-linux-gnu" = {
      url = "https://github.com/Mergifyio/mergify-cli/releases/download/${version}/mergify-${version}-x86_64-unknown-linux-gnu.tar.gz";
      sha256 = "sha256-o8qo5RfEMgqoxyzp+sTmVyIlzBEvtU/iZPD/6HgHz4U=";
    };
    "aarch64-unknown-linux-gnu" = {
      url = "https://github.com/Mergifyio/mergify-cli/releases/download/${version}/mergify-${version}-aarch64-unknown-linux-gnu.tar.gz";
      sha256 = "sha256-1zWkkdxIeMc3aLxNxCGGhcJtTFAnzpBwlOdRCRIwIHA=";
    };
    "x86_64-apple-darwin" = {
      url = "https://github.com/Mergifyio/mergify-cli/releases/download/${version}/mergify-${version}-x86_64-apple-darwin.tar.gz";
      sha256 = "sha256-oQ5oYBgCREDyAlDjEpdEzWLd7N19As8gOPfCjPuilwc=";
    };
    "aarch64-apple-darwin" = {
      url = "https://github.com/Mergifyio/mergify-cli/releases/download/${version}/mergify-${version}-aarch64-apple-darwin.tar.gz";
      sha256 = "sha256-yDwZiwJ7wNw4a29W6zMGHz3+Vhv606KhQEFgk1yOUko=";
    };
  };

  srcInfo = sources.${target};

in
stdenv.mkDerivation {
  pname = "mergify-cli";
  inherit version;

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchurl {
    inherit (srcInfo) url sha256;
  };

  nativeBuildInputs = lib.optional stdenv.hostPlatform.isLinux autoPatchelfHook;
  buildInputs = [
    stdenv.cc.cc.lib # Provides libgcc_s.so.1
  ];

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    tar -xzf $src
    install -Dm755 mergify $out/bin/mergify

    runHook postInstall
  '';

  meta = with lib; {
    mainProgram = "mergify";
    description = "Official CLI for Mergify";
    homepage = "https://github.com/Mergifyio/mergify-cli";
    license = licenses.unfree;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    maintainers = with maintainers; [ arntanguy ];
  };
}
