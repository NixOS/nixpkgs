{
  lib,
  stdenv,
  fetchzip,
  python3,
  librandombytes,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libcpucycles";
  version = "20240318";

  src = fetchzip {
    url = "https://cpucycles.cr.yp.to/libcpucycles-${finalAttrs.version}.tar.gz";
    hash = "sha256-Fb73EOHGgEehZJwTCtCG12xwyiqtDXFs9eFDsHBQiDo=";
  };

  postPatch = ''
    patchShebangs configure
    patchShebangs scripts-build
  '';

  nativeBuildInputs = [ python3 ];

  inherit (librandombytes) hardeningDisable configurePlatforms env;

  preFixup = lib.optionalString stdenv.isDarwin ''
    install_name_tool -id "$out/lib/libcpucycles.1.dylib" "$out/lib/libcpucycles.1.dylib"
    install_name_tool -change "libcpucycles.1.dylib" "$out/lib/libcpucycles.1.dylib" "$out/bin/cpucycles-info"
  '';

  meta = {
    homepage = "https://cpucycles.cr.yp.to/";
    description = "Microlibrary for counting CPU cycles";
    changelog = "https://cpucycles.cr.yp.to/download.html";
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
    # list of architectures it supports, but currentlly untested with nix https://cpucycles.cr.yp.to/libcpucycles-20240318/cpucycles/options.html
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ] ++ lib.platforms.darwin;
  };
})
