{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config, glib, expat
, installShellFiles }:

stdenv.mkDerivation rec {
  pname = "prevo-tools";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "bpeel";
    repo = "prevodb";
    rev = version;
    sha256 = "1fyrc4g9qdq04nxs4g8x0krxfani5xady6v9m0qfqpbh4xk2ry2d";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config installShellFiles ];
  buildInputs = [ glib expat ];

  postInstall = ''
    installShellCompletion --bash src/prevo-completion
  '';

  meta = {
    description =
      "CLI tools for the offline version of the Esperanto dictionary Reta Vortaro";
    longDescription = ''
      PReVo is the "portable" ReVo, i.e., the offline version
      of the Esperanto dictionary Reta Vortaro.

      This package provides the command line application prevo to query a local
      ReVo database, as well as the command line tool revodb to create such a
      database for this application or for the Android app of the same name.
    '';
    homepage = "https://github.com/bpeel/prevodb";
    license = lib.licenses.gpl2Only;
    mainProgram = "prevo";
    maintainers = with lib.maintainers; [ das-g ehmry ];
    platforms = lib.platforms.unix;
  };
}
