{
  lib,
  stdenv,
  fetchFromGitHub,
  perl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "deer";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "Vifon";
    repo = "deer";
    rev = "v${finalAttrs.version}";
    sha256 = "1xnbnbi0zk2xsyn8dqsmyxqlfnl36pb1wwibnlp0dxixw6sfymyl";
  };

  strictDeps = true;

  prePatch = ''
    substituteInPlace deer \
      --replace " perl " " ${perl}/bin/perl "
  '';

  patches = [ ./realpath.patch ];

  installPhase = ''
    mkdir -p $out/share/zsh/site-functions/
    cp deer $out/share/zsh/site-functions/
  '';

  meta = {
    description = "Ranger-like file navigation for zsh";
    homepage = "https://github.com/Vifon/deer";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
