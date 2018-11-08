{ stdenv, lib, fetchFromGitHub, alex, happy, Agda, agdaIowaStdlib,
  buildPlatform, buildPackages, ghcWithPackages, fetchpatch }:
let
  options-patch =
    fetchpatch {
      url = https://github.com/cedille/cedille/commit/ee62b0fabde6c4f7299a3778868519255cc4a64f.patch;
      name = "options.patch";
      sha256 = "19xzn9sqpfnfqikqy1x9lb9mb6722kbgvrapl6cf8ckcw8cfj8cz";
      };
in
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

  patches = [options-patch];

  LANG = "en_US.UTF-8";
  LOCALE_ARCHIVE =
    lib.optionalString (buildPlatform.libc == "glibc")
      "${buildPackages.glibcLocales}/lib/locale/locale-archive";

  postPatch = ''
    patchShebangs create-libraries.sh
    cp -r ${agdaIowaStdlib.src} ial
    chmod -R 755 ial
  '';

  outputs = ["out" "lib"];

  installPhase = ''
    mkdir -p $out/bin
    mv cedille $out/bin/cedille
    mv lib $lib
  '';

  meta = {
    description = "An interactive theorem-prover and dependently typed programming language, based on extrinsic (aka Curry-style) type theory.";
    homepage = https://cedille.github.io/;
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.mpickering ];
    platforms = stdenv.lib.platforms.unix;
  };
}
