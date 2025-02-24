{
  lib,
  stdenv,
  fetchFromGitHub,
  openssl,
}:
let
  makefile = if stdenv.hostPlatform.isDarwin then "makefile.mac" else "makefile";
in
stdenv.mkDerivation rec {
  pname = "ibm-sw-tpm2";
  version = "1682-unstable-2024-08-02";

  src = fetchFromGitHub {
    owner = "kgoldman";
    repo = "ibmswtpm2";
    rev = "rev183-2024-08-02";
    hash = "sha256-D2GAkiePBow2iixYMOOeJrnh5hk2lO07dV++lK4X8qE=";
  };

  buildInputs = [ openssl ];

  sourceRoot = "${src.name}/src";

  inherit makefile;

  prePatch = ''
    # Fix hardcoded path to GCC.
    substituteInPlace ${makefile} --replace /usr/bin/gcc "${stdenv.cc}/bin/cc"

    # Remove problematic default CFLAGS.
    substituteInPlace ${makefile} \
      --replace -Werror "" \
      --replace -O0 "" \
      --replace -ggdb ""
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp tpm_server $out/bin
  '';

  meta = with lib; {
    description = "IBM's Software TPM 2.0, an implementation of the TCG TPM 2.0 specification";
    mainProgram = "tpm_server";
    homepage = "https://sourceforge.net/projects/ibmswtpm2/";
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ tomfitzhenry ];
    license = licenses.bsd3;
  };
}
