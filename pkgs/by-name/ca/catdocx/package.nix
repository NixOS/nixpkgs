{
  stdenv,
  lib,
  fetchFromGitHub,
  makeWrapper,
  unzip,
  catdoc,
}:

stdenv.mkDerivation {
  pname = "catdocx";
  version = "0-unstable-2017-01-02";

  src = fetchFromGitHub {
    owner = "jncraton";
    repo = "catdocx";
    rev = "04fa0416ec1f116d4996685e219f0856d99767cb";
    sha256 = "1sxiqhkvdqn300ygfgxdry2dj2cqzjhkzw13c6349gg5vxfypcjh";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/libexec $out/bin
    cp catdocx.sh $out/libexec
    chmod +x $out/libexec/catdocx.sh
    wrapProgram $out/libexec/catdocx.sh --prefix PATH : "${
      lib.makeBinPath [
        unzip
        catdoc
      ]
    }"
    ln -s $out/libexec/catdocx.sh $out/bin/catdocx
  '';

  meta = {
    description = "Extracts plain text from docx files";
    mainProgram = "catdocx";
    homepage = "https://github.com/jncraton/catdocx";
    license = with lib.licenses; [ bsd3 ];
    maintainers = [ lib.maintainers.michalrus ];
    platforms = lib.platforms.all;
  };
}
