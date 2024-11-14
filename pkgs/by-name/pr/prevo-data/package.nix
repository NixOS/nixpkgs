{ lib, stdenv, fetchFromGitHub, prevo-tools }:

stdenv.mkDerivation {
  pname = "prevo-data";
  version = "2020-03-08";

  src = fetchFromGitHub {
    owner = "bpeel";
    repo = "revo";
    rev = "1e8d7197c0bc831e2127909e77e64dfc26906bdd";
    hash = "sha256-308IDx/9LXauvtyjiC9GlHWOj9VMnYy21ouVNuL9sNE=";
  };

  nativeBuildInputs = [ prevo-tools ];

  dontUnpack = true;

  buildPhase = ''
    prevodb -s -i $src -o prevo.db
  '';

  installPhase = ''
    mkdir -p $out/share/prevo
    cp prevo.db $out/share/prevo/
  '';

  meta = {
    description =
      "data for offline version of the Esperanto dictionary Reta Vortaro";
    longDescription = ''
      PReVo is the "portable" ReVo, i.e., the offline version
      of the Esperanto dictionary Reta Vortaro.

      This package provides the ReVo database for the prevo command line application.
    '';
    homepage = "https://github.com/bpeel/revo";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ das-g ehmry ];
  };
}
