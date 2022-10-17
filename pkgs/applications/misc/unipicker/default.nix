{ stdenv, fetchFromGitHub, lib, fzf, xclip }:

stdenv.mkDerivation rec {
   pname = "unipicker";
   version = "2.0.1";

   src = fetchFromGitHub {
      owner = "jeremija";
      repo = pname;
      rev = "v${version}";
      sha256 = "1k4v53pm3xivwg9vq2kndpcmah0yn4679r5jzxvg38bbkfdk86c1";
   };

   buildInputs = [
      fzf
      xclip
   ];

   preInstall = ''
      substituteInPlace unipicker \
        --replace "/etc/unipickerrc" "$out/etc/unipickerrc" \
        --replace "fzf" "${fzf}/bin/fzf"
      substituteInPlace unipickerrc \
        --replace "/usr/local" "$out" \
        --replace "fzf" "${fzf}/bin/fzf"
   '';

   makeFlags = [
      "PREFIX=$(out)"
      "DESTDIR=$(out)"
   ];

   meta = with lib; {
    description = "A CLI utility for searching unicode characters by description and optionally copying them to clipboard";
    homepage = "https://github.com/jeremija/unipicker";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
   };
}
