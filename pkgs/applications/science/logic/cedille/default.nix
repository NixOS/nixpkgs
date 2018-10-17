{ stdenv, lib, fetchFromGitHub, alex, happy, Agda, agdaIowaStdlib,
  buildPlatform, buildPackages, ghcWithPackages }:
stdenv.mkDerivation rec {
  version = "1.0.0";
  name = "cedille-${version}";
  src = fetchFromGitHub {
    owner = "cedille";
    repo = "cedille";
    rev = "v${version}";
    sha256 = "08c2vgg8i6l3ws7hd5gsj89mki36lxm7x7s8hi1qa5gllq04a832";
  };
  buildInputs = [ alex happy Agda (ghcWithPackages (ps: [ps.ieee])) ];

  LANG = "en_US.UTF-8";
  LOCALE_ARCHIVE =
    lib.optionalString (buildPlatform.libc == "glibc")
      "${buildPackages.glibcLocales}/lib/locale/locale-archive";

  postPatch = ''
    patchShebangs create-libraries.sh
    cp -r ${agdaIowaStdlib.src} ial
    chmod -R 755 ial
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv cedille $out/bin/cedille
  '';

  meta = {
    description = "An interactive theorem-prover and dependently typed programming language, based on extrinsic (aka Curry-style) type theory.";
    homepage = https://cedille.github.io/;
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.mpickering ];
    platforms = stdenv.lib.platforms.unix;
  };
}
