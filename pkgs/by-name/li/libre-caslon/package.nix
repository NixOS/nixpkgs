{
  lib,
  stdenv,
  fetchFromGitHub,
  installFonts,
}:

stdenv.mkDerivation rec {
  pname = "libre-caslon";
  version = "1.002";

  srcs = [
    (fetchFromGitHub {
      owner = "impallari";
      repo = "Libre-Caslon-Text";
      rev = "c31e21f7e8cf91f18d90f778ce20e66c68219c74";
      name = "libre-caslon-text-${version}-src";
      sha256 = "0zczv9qm8cgc7w1p64mnf0p0fi7xv89zhf1zzf1qcna15kbgc705";
    })

    (fetchFromGitHub {
      owner = "impallari";
      repo = "Libre-Caslon-Display";
      rev = "3491f6a9cfde2bc15e736463b0bc7d93054d5da1";
      name = "libre-caslon-display-${version}-src";
      sha256 = "12jrny3y8w8z61lyw470drnhliji5b24lgxap4w3brp6z3xjph95";
    })
  ];

  sourceRoot = ".";

  nativeBuildInputs = [ installFonts ];

  postInstall = ''
    install -Dm444 \
      libre-caslon-text-${version}-src/{README.md,FONTLOG.txt} \
      -t $out/share/doc/${pname}-${version}
  '';

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "sha256-hIfkLzUzpiWN6Z+L7RZqX0+h8e6RFbmQ3kRXGe3uxjw=";

  meta = {
    description = "Caslon fonts based on hand-lettered American Caslons of 1960s";
    homepage = "http://www.impallari.com/librecaslon";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ pancaek ];
    platforms = lib.platforms.all;
  };
}
