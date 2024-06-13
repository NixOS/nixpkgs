{ stdenv
, lib
, python3
, openssl
, fetchzip
, librandombytes
, libcpucycles
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

  # NOTE: librandombytes uses a custom Python `./configure`: it does not expect standard
  # autoconfig --build --host etc. arguments: disable
  configurePlatforms = [ ];

  # NOTE: the librandombytes library has required specific CFLAGS defined:
  # https://randombytes.cr.yp.to/librandombytes-20240318/compilers/default.html
  # - `-Qunused-arguments` suppress clang warning
  env.NIX_CFLAGS_COMPILE = toString
    (lib.optionals stdenv.cc.isClang [ "-Qunused-arguments" ]);

  nativeBuildInputs = [ python3 ];
  buildInputs = [ librandombytes libcpucycles ];

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
    platforms = [ "x86_64-linux" "aarch64-linux" ];
  };
})
