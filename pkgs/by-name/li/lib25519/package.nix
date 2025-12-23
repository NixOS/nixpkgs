{
  stdenv,
  lib,
  python3,
  fetchzip,
  testers,
  valgrind,
  librandombytes,
  libcpucycles,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "lib25519";
  version = "20241004";

  src = fetchzip {
    url = "https://lib25519.cr.yp.to/lib25519-${finalAttrs.version}.tar.gz";
    hash = "sha256-gKLMk+yZ/nDlwohZiCFurSZwHExX3Ge2W1O0JoGQf8M=";
  };

  patches = [ ./environment-variable-tools.patch ];

  postPatch = ''
    patchShebangs configure
    patchShebangs scripts-build
  '';

  # NOTE: lib25519 uses a custom Python `./configure`: it does not expect standard
  # autoconfig --build --host etc. arguments: disable
  # Pass the hostPlatform string
  configurePhase = ''
    runHook preConfigure
    ./configure --host=${stdenv.buildPlatform.system} --prefix=$out
    runHook postConfigure
  '';

  nativeBuildInputs = [
    python3
    valgrind
  ];
  buildInputs = [
    librandombytes
    libcpucycles
  ];

  preFixup = lib.optionalString stdenv.hostPlatform.isDarwin ''
    install_name_tool -id "$out/lib/lib25519.1.dylib" "$out/lib/lib25519.1.dylib"
    for f in $out/bin/*; do
      install_name_tool -change "lib25519.1.dylib" "$out/lib/lib25519.1.dylib" "$f"
    done
  '';

  # failure: crypto_pow does not handle p=q overlap
  doInstallCheck = !stdenv.hostPlatform.isDarwin;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/lib25519-test
    runHook postInstallCheck
  '';

  passthru = {
    updateScript = ./update.sh;
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "lib25519-test | head -n 2 | grep version";
      version = "lib25519 version ${finalAttrs.version}";
    };
  };

  meta = {
    homepage = "https://randombytes.cr.yp.to/";
    description = "Simple API for applications generating fresh randomness";
    changelog = "https://randombytes.cr.yp.to/download.html";
    license = with lib.licenses; [
      # Upstream specifies the public domain licenses with the terms here https://cr.yp.to/spdx.html
      publicDomain
      cc0
      bsd0
      mit
      mit0
    ];
    maintainers = with lib.maintainers; [
      kiike
      imadnyc
      jleightcap
    ];
    teams = with lib.teams; [ ngi ];
    # This supports whatever platforms libcpucycles supports
    inherit (libcpucycles.meta) platforms;
  };
})
