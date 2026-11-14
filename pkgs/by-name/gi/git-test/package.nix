{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  git,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "git-test";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "spotify";
    repo = "git-test";
    rev = "v${finalAttrs.version}";
    hash = "sha256-TlR3Rk9cekIC5a4puX7JD4q0A7Bmjhz5PTfsZhVwAwY=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    install -m755 -Dt $out/bin git-test
    install -m444 -Dt $out/share/man/man1 git-test.1

    wrapProgram $out/bin/git-test \
      --prefix PATH : "${lib.makeBinPath [ git ]}"
  '';

  meta = {
    description = "Test your commits";
    homepage = "https://github.com/spotify/git-test";
    license = lib.licenses.asl20;
    maintainers = [ ];
    platforms = lib.platforms.all;
    mainProgram = "git-test";
  };
})
