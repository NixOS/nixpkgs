{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hactool";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "SciresM";
    repo = "hactool";
    rev = finalAttrs.version;
    hash = "sha256-TSBALKs5Rvv/miCn8J3tAiBKolYueujfvxZVbvWzBQw=";
  };

  patches = [ ./musl-compat.patch ];

  preBuild = ''
    mv config.mk.template config.mk
  '';

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];
  enableParallelBuilding = true;

  installPhase = ''
    install -D hactool${stdenv.hostPlatform.extensions.executable} $out/bin/hactool${stdenv.hostPlatform.extensions.executable}
  '';

  meta = {
    homepage = "https://github.com/SciresM/hactool";
    description = "Tool to manipulate common file formats for the Nintendo Switch";
    longDescription = "A tool to view information about, decrypt, and extract common file formats for the Nintendo Switch, especially Nintendo Content Archives";
    license = lib.licenses.isc;
    maintainers = [ ];
    platforms = lib.platforms.all;
    mainProgram = "hactool";
  };
})
