{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchpatch,
  cmake,
  installShellFiles,
  bison,
  boost,
  flex,
  gmp,
  libxml2,
  mpfi,
  mpfr,
  scalp,
  sollya,
  wcpg,
}:

stdenv.mkDerivation rec {
  pname = "flopoco";
  version = "4.1.3";

  src = fetchFromGitLab {
    owner = pname;
    repo = pname;
    # flopoco-4.1.3 is not tagged on GitLab
    rev = "67598298207c9f3261c35679c8a5966480c4343c";
    sha256 = "sha256-0jRjg4/qciqBcjsi6BTbKO4VJkcoEzpC98wFkUOIGbI=";
  };

  patches = [
    (fetchpatch {
      name = "fix-clang-error-sin-cos.patch";
      url = "https://gitlab.com/flopoco/flopoco/-/commit/de3aa60ad19333952c176c2a2e51f12653ca736b.patch";
      postFetch = ''
        substituteInPlace $out \
          --replace 'FixSinCosCORDIC.hpp' 'CordicSinCos.hpp'
      '';
      sha256 = "sha256-BlamA/MZuuqqvGYto+jPeQPop6gwva0y394Odw8pdwg=";
    })
    (fetchpatch {
      name = "fix-clang-error-atan2.patch";
      url = "https://gitlab.com/flopoco/flopoco/-/commit/a3ffe2436c1b59ee0809b3772b74f2d43c6edb99.patch";
      sha256 = "sha256-dSYcufLHDL0p1V1ghmy6X6xse5f6mjUqckaVqLZnTaA=";
    })
  ];

  postPatch = lib.optionalString (stdenv.isDarwin && stdenv.isx86_64) ''
    sed -i "s/-pg//g" {,src/Apps/TaMaDi/}CMakeLists.txt
  '';

  strictDeps = true;

  nativeBuildInputs = [
    bison
    cmake
    installShellFiles
  ];

  buildInputs = [
    boost
    flex
    gmp
    libxml2
    mpfi
    mpfr
    scalp
    sollya
    wcpg
  ];

  postBuild = ''
    ./flopoco BuildAutocomplete
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 flopoco $out/bin/flopoco
    cp bin* fp* ieee* longacc* $out/bin/
    installShellCompletion --bash flopoco_autocomplete

    runHook postInstall
  '';

  meta = with lib; {
    description = "The FloPoCo arithmetic core generator";
    homepage = "https://flopoco.org/";
    license = licenses.unfree;
    platforms = platforms.unix;
    maintainers = with maintainers; [ wegank ];
  };
}
