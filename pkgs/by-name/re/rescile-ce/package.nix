{
  lib,
  stdenv,
  fetchurl,
  patchelf,
  testers,
}:

let
  version = "0.1.187";

  # Map Nix host platforms to the upstream pre-built binaries
  platform =
    if stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isx86_64 then
      {
        url = "https://updates.rescile.com/v${version}/rescile-ce-linux-amd64";
        hash = "sha256-NJyCGTFhNk2rm04WyVKxZ/1n/P+61BU/BkW56gR50zc=";
      }
    else if stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64 then
      {
        url = "https://updates.rescile.com/v${version}/rescile-ce-darwin-arm64";
        hash = "sha256-Pwjlajyl+YJ2X1fgYgbJOvV4hAdH7LUDEXkakYmFReE=";
      }
    else
      throw "Unsupported platform: ${stdenv.hostPlatform.system}";

in
stdenv.mkDerivation (finalAttrs: {
  pname = "rescile-ce";
  inherit version;

  src = fetchurl {
    inherit (platform) url hash;
  };

  # These MUST be top-level attributes
  strictDeps = true;
  __structuredAttrs = true;

  dontUnpack = true;

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ patchelf ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp $src $out/bin/rescile-ce
    chmod +x $out/bin/rescile-ce

    runHook postInstall
  '';

  # For Linux, pre-compiled binaries need their interpreter and runpaths patched to find Nix libraries
  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${lib.makeLibraryPath [ stdenv.cc.cc ]}" \
      $out/bin/rescile-ce
  '';

  # Providing a test makes ofBorg happy and ensures your binary actually executes!
  passthru.tests = {
    version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "rescile-ce --version"; # Adjust if the help/version command is different
    };
  };

  meta = {
    description = "Rescile Collaborative Engine";
    homepage = "https://rescile.com";
    license = lib.licenses.unfreeRedistributable;
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    maintainers = [ ]; # Add your GitHub handle here if you are maintaining it!
    platforms = [
      "x86_64-linux"
      "aarch64-darwin"
    ];
    mainProgram = "rescile-ce";
  };
})
