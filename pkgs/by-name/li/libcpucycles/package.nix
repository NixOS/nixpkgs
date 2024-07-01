{
  stdenv,
  lib,
  python3,
  fetchzip,
}:
stdenv.mkDerivation (prev: {
  pname = "libcpucycles";
  version = "20240318";

  src = fetchzip {
    url = "https://cpucycles.cr.yp.to/libcpucycles-${prev.version}.tar.gz";
    hash = "sha256-Fb73EOHGgEehZJwTCtCG12xwyiqtDXFs9eFDsHBQiDo=";
  };

  # NOTE: librandombytes uses a custom Python `./configure`: it does not expect standard
  # autoconfig --build --host etc. arguments: disable
  configurePlatforms = [  ];

  # NOTE: the librandombytes library has required specific CFLAGS defined:
  # https://randombytes.cr.yp.to/librandombytes-20240318/compilers/default.html
  # - `-O` (alias `-O1`) safe optimization
  # - `-Qunused-arguments` suppress clang warning
  # the default "fortify" hardening sets -O2, -D_FORTIFY_SOURCE=2:
  # since librandombytes uses -O1, we disable the fortify hardening, and then manually re-enable -D_FORTIFY_SOURCE.
  hardeningDisable = [ "fortify" ];
  env.NIX_CFLAGS_COMPILE = toString (
    lib.optionals stdenv.cc.isClang [ "-Qunused-arguments" ]
    ++ [
      "-D_FORTIFY_SOURCE=2"
      "-O1"
    ]
  );

  # TODO: Fix this patch for cross comp. later
  # patches = [ ./cross.patch ];

  nativeBuildInputs = [ python3 ];

  preConfigure = ''
    patchShebangs configure
    patchShebangs scripts-build
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
    # https://cpucycles.cr.yp.to/install.html should be easy to port to darwin, but currently doesn't work
    # list of architectures it supports, but currentlly untested with nix https://cpucycles.cr.yp.to/libcpucycles-20240318/cpucycles/options.html
    platforms = [ "x86_64-linux" "aarch64-linux"];
  };

})
