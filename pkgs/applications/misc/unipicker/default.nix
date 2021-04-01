{ stdenv, fetchFromGitHub, lib, fzf, xclip }:

stdenv.mkDerivation rec {
   pname = "unipicker";
   version = "unstable-2018-07-10";

   src = fetchFromGitHub {
      owner = "jeremija";
      repo = pname;
      rev = "767571c87cdb1e654408d19fc4db98e5e6725c04";
      sha256 = "1k4v53pm3xivwg9vq2kndpcmah0yn4679r5jzxvg38bbkfdk86c1";
   };

   buildInputs = [
      fzf
      xclip
   ];

   preInstall = ''
      substituteInPlace unipicker --replace "/etc/unipickerrc" "$out/etc/unipickerrc"
      substituteInPlace unipickerrc --replace "/usr/local" "$out"
   '';

   makeFlags = [
      "PREFIX=$(out)"
      "DESTDIR=$(out)"
   ];

   meta = with lib; {
    description = "A CLI utility for searching unicode characters by description and optionally copying them to clipboard";
    homepage = "https://github.com/jeremija/unipicker";
    license = licenses.mit;
    maintainers = with maintainers; [ kiyengar ];
    platforms = with platforms; unix;
   };
}
