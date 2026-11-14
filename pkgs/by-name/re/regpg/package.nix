{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  gnupg,
  perl,
}:

let
  perlEnv = perl.withPackages (p: with p; [ TextMarkdown ]);
in
stdenv.mkDerivation (finalAttrs: {
  pname = "regpg";
  version = "1.11";

  src = fetchFromGitHub {
    owner = "fanf2";
    repo = "regpg";
    rev = "regpg-${finalAttrs.version}";
    hash = "sha256-LqmZUIBAeBkOHMKnbUdA4/3VOVqQQ9s/P+hr8kd9On0=";
  };

  nativeBuildInputs = [
    makeWrapper
    perlEnv
  ];

  postPatch = ''
    patchShebangs ./util/insert-here.pl ./util/markdown.pl
    substituteInPlace ./Makefile \
      --replace 'util/insert-here.pl' 'perl util/insert-here.pl'
    substituteInPlace ./Makefile \
      --replace 'util/markdown.pl' 'perl util/markdown.pl'
    substituteInPlace util/insert-here.pl \
      --replace 'qx(git describe)' '"regpg-${finalAttrs.version}"'
  '';

  dontConfigure = true;

  makeFlags = [ "prefix=$(out)" ];

  postFixup = ''
    patchShebangs $out/bin/regpg
    wrapProgram $out/bin/regpg --prefix PATH ":" \
      "${lib.makeBinPath [ gnupg ]}"
  '';

  meta = {
    description = "GPG wrapper utility for storing secrets in VCS";
    mainProgram = "regpg";
    homepage = "https://dotat.at/prog/regpg";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ _0xC45 ];
  };
})
