{
  lib,
  stdenv,
  fetchurl,
  patchelf,
}:
let
  version = "0.1.185";

  platform =
    if stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isx86_64 then
      {
        url = "https://updates.rescile.com/v${version}/rescile-ce-linux-amd64";
        sha256 = "a6bfe6230e7ef6d62dfa1217274a05ed9ac95228df52a3bdfeece64746fa6839"; # Adjust if 0.1.185 hash differs
        metaPlatforms = [ "x86_64-linux" ];
      }
    else if stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64 then
      {
        url = "https://updates.rescile.com/v${version}/rescile-ce-darwin-arm64";
        sha256 = "5546c884b4b5200936d35eb6a5ad8634ace93c01d67229a955011678ce5d773a"; # Adjust if 0.1.185 hash differs
        metaPlatforms = [ "aarch64-darwin" ];
      }
    else
      throw "rescile-ce: unsupported platform ${stdenv.hostPlatform.system}";
in
stdenv.mkDerivation {
  pname = "rescile-ce";
  inherit version;

  src = fetchurl {
    inherit (platform) url sha256;
  };

  dontUnpack = true;

  # Mandatory modern Nixpkgs standards flags
  strictDeps = true;
  __structuredAttrs = true;

  installPhase = ''
    mkdir -p $out/bin
    install -Dm755 $src $out/bin/rescile-ce
  '';

  fixupPhase = lib.optionalString stdenv.hostPlatform.isLinux ''
    ${patchelf}/bin/patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${lib.makeLibraryPath [ stdenv.cc.cc.lib ]}" \
      $out/bin/rescile-ce
  '';

  meta = {
    description = "Rescile Community Edition";
    homepage = "https://www.rescile.com";
    license = lib.licenses.unfreeRedistributable;
    platforms = platform.metaPlatforms;
    mainProgram = "rescile-ce";
  };
}
