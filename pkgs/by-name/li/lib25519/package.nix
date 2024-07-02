{
  stdenv,
  lib,
  python3,
  fetchzip,
  librandombytes,
  libcpucycles,
  system ? builtins.currentSystem,
}:
stdenv.mkDerivation (prev: {
  pname = "lib25519";
  version = "20240321";

  src = fetchzip {
    url = "https://lib25519.cr.yp.to/lib25519-${prev.version}.tar.gz";
    hash = "sha256-R10Q803vCjIZCS4Z/uErsx547RaXfAELGQm9NuNhw+I=";
  };

  preConfigure = ''
    patchShebangs configure
    patchShebangs scripts-build
  '';
  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/lib25519-test
  '';

  # NOTE: lib25519 uses a custom Python `./configure`: it does not expect standard
  # autoconfig --build --host etc. arguments: disable
  # Pass the hostPlatform string
  configurePhase = ''
    runHook preConfigure
    ./configure --host=${system} --prefix=$out
    runHook postConfigure
  '';

  patches = [ ./environment-variable-tools.patch ];

  nativeBuildInputs = [ python3 ];
  buildInputs = [
    librandombytes
    libcpucycles
  ];

  meta = {
    homepage = "https://randombytes.cr.yp.to/";
    description = "A simple API for applications generating fresh randomness";
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
    # This supports whatever platforms libcpucycles supports
    inherit (libcpucycles.meta) platforms;
  };
})
