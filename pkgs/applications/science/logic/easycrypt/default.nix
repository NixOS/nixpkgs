{ lib, stdenv, fetchFromGitHub, fetchpatch, ocamlPackages, why3 }:

stdenv.mkDerivation rec {
  pname = "easycrypt";
  version = "2022.04";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "r${version}";
    sha256 = "sha256:09rdwcj70lkamkhd895p284rfpz4bcnsf55mcimhiqncd2a21ml7";
  };

  patches = lib.lists.map fetchpatch [
    # Fix build with Why3 1.5
    { url = "https://github.com/EasyCrypt/easycrypt/commit/d226387432deb7f22738e1d5579346a2cbc9be7a.patch";
      hash = "sha256:1zvxij35fnr3h9b5wdl8ml17aqfx3a39rd4mgwmdvkapbg3pa4lm"; }
    # Fix build with Why3 1.6
    { url = "https://github.com/EasyCrypt/easycrypt/commit/876f2ed50a0434afdf2fb20e7c50b8a3e26bb06e.patch";
      hash = "sha256-UycfLZWYHNsppb7qHSRaAF4Y0UnwoFueEG0wUcBUPYE="; }
  ];

  nativeBuildInputs = with ocamlPackages; [
    dune_3
    findlib
    menhir
    ocaml
  ];
  buildInputs = with ocamlPackages; [
    batteries
    dune-build-info
    inifiles
    yojson
    zarith
  ];

  propagatedBuildInputs = [ why3 ];

  strictDeps = true;

  postPatch = ''
    substituteInPlace dune-project --replace '(name easycrypt)' '(name easycrypt)(version ${version})'
  '';

  installPhase = ''
    runHook preInstall
    dune install --prefix $out ${pname}
    rm $out/bin/ec-runtest
    runHook postInstall
  '';

  meta = {
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
    platforms = lib.platforms.all;
    homepage = "https://easycrypt.info/";
    description = "Computer-Aided Cryptographic Proofs";
  };
}
