{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,
  trash-cli,
  coreutils,
  which,
  getopt,
}:

stdenvNoCC.mkDerivation rec {
  pname = "rmtrash";
  version = "1.15";

  src = fetchFromGitHub {
    owner = "PhrozenByte";
    repo = "rmtrash";
    rev = "v${version}";
    sha256 = "sha256-vCtIM6jAYfrAOopiTcb4M5GNtucVnK0XEEKbMq1Cbc4=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    for f in rm{,dir}trash; do
      install -D ./$f $out/bin/$f
      wrapProgram $out/bin/$f \
        --prefix PATH : ${
          lib.makeBinPath [
            trash-cli
            coreutils
            which
            getopt
          ]
        }
    done
  '';

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    homepage = "https://github.com/PhrozenByte/rmtrash";
    description = "Trash-put made compatible with GNUs rm and rmdir";
    longDescription = ''
      Put files (and directories) in trash using the `trash-put` command in a
      way that is, otherwise as `trash-put` itself, compatible to GNUs `rm`
      and `rmdir`.
    '';
<<<<<<< HEAD
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ peelz ];
    platforms = lib.platforms.all;
=======
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ peelz ];
    platforms = platforms.all;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
