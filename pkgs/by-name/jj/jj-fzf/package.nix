{
  lib,
  bashInteractive,
  coreutils,
  fetchFromGitHub,
  fzf,
  gawk,
  gnused,
  jujutsu,
  python3,
  makeWrapper,
  stdenv,
  util-linux,
  pandoc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jj-fzf";
  version = "0.34.0";

  src = fetchFromGitHub {
    owner = "tim-janik";
    repo = "jj-fzf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aJyKVMg/yI2CmAx5TxN0w670Rq26ESdLzESgh8Jr4nE=";
  };

  nativeBuildInputs = [
    makeWrapper
    pandoc
  ];

  buildInputs = [
    bashInteractive
    jujutsu
    fzf
    gawk
    gnused
    coreutils
    util-linux
    python3
  ];

  postPatch = ''
    patchShebangs .
  '';

  installFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    rm -f $out/libexec/jj-fzf-*/{README.md,NEWS.md,sfx.sh}
     patchShebangs $out
     wrapProgram $out/bin/jj-fzf \
       --prefix PATH : ${lib.makeBinPath finalAttrs.buildInputs}
  '';

  meta = {
    description = "Text UI for Jujutsu based on fzf";
    homepage = "https://github.com/tim-janik/jj-fzf";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ bbigras ];
    platforms = lib.platforms.all;
    mainProgram = "jj-fzf";
  };
})
