{
  lib,
  stdenv,
  fetchFromGitHub,
  glibc,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "0xtools";
<<<<<<< HEAD
  version = "3.0.3";
=======
  version = "2.0.3";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "tanelpoder";
    repo = "0xtools";
    rev = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-mHd4NFp+QB+TTBLeuEeJVdgQ2r8CM4CfZC515t/3u94=";
=======
    hash = "sha256-QWH3sKYFiEWuexZkMlyWQPHmKJpcaiWI5szhdx5yKtM=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "Utilities for analyzing application performance";
    homepage = "https://0x.tools";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ astro ];
=======
  meta = with lib; {
    description = "Utilities for analyzing application performance";
    homepage = "https://0x.tools";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ astro ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    platforms = [ "x86_64-linux" ];
  };
})
