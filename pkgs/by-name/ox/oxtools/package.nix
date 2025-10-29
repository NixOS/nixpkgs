{
  lib,
  stdenv,
  fetchFromGitHub,
  glibc,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "0xtools";
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "tanelpoder";
    repo = "0xtools";
    rev = "v${finalAttrs.version}";
    hash = "sha256-QWH3sKYFiEWuexZkMlyWQPHmKJpcaiWI5szhdx5yKtM=";
  };

  postPatch = ''
    substituteInPlace lib/0xtools/psnproc.py \
      --replace /usr/include/asm/unistd_64.h ${glibc.dev}/include/asm/unistd_64.h
  '';

  buildInputs = [ python3 ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  preInstall = ''
    mkdir -p $out/bin
  '';

  meta = {
    description = "Utilities for analyzing application performance";
    homepage = "https://0x.tools";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ astro ];
    platforms = [ "x86_64-linux" ];
  };
})
