{ stdenv, fetchFromGitHub, makeWrapper
, shntool, cuetools
, flac, faac, mp4v2, wavpack, mac
, imagemagick, libiconv, enca, lame, pythonPackages, vorbis-tools
, aacgain, mp3gain, vorbisgain
}:

let
  wrapSplit2flac =  format: ''
    makeWrapper $out/bin/.split2flac-wrapped $out/bin/split2${format} \
      --set SPLIT2FLAC_FORMAT ${format} \
      --prefix PATH : ${stdenv.lib.makeBinPath [
        shntool cuetools
        flac faac mp4v2 wavpack mac
        imagemagick libiconv enca lame pythonPackages.mutagen vorbis-tools
        aacgain mp3gain vorbisgain
      ]}
  '';

in stdenv.mkDerivation rec {
  name = "split2flac-${version}";
  version = "122";

  src = fetchFromGitHub {
    owner = "ftrvxmtrx";
    repo = "split2flac";
    rev = version;
    sha256 = "1a71amamip25hhqx7wwzfcl3d5snry9xsiha0kw73iq2m83r2k63";
  };

  dontBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  patchPhase = ''
    substituteInPlace split2flac \
      --replace 'FORMAT="''${0##*split2}"' 'FORMAT=''${SPLIT2FLAC_FORMAT:-flac}'
  '';

  installPhase = ''
    mkdir -p $out/share/bash-completion/completions
    cp split2flac-bash-completion.sh \
      $out/share/bash-completion/completions/split2flac-bash-completion.sh

    mkdir -p $out/bin
    cp split2flac $out/bin/.split2flac-wrapped

    ${wrapSplit2flac "flac"}
    ${wrapSplit2flac "mp3"}
    ${wrapSplit2flac "ogg"}
    ${wrapSplit2flac "m4a"}
    ${wrapSplit2flac "wav"}
  '';

  meta = with stdenv.lib; {
    description = "Split flac/ape/wv/wav + cue sheet into separate tracks";
    homepage = https://github.com/ftrvxmtrx/split2flac;
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ jfrankenau ];
  };
}
