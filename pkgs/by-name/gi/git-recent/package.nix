{
  lib,
  stdenv,
  fetchFromGitHub,
  makeBinaryWrapper,
  gitMinimal,
  less,
  util-linuxMinimal,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "git-recent";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "paulirish";
    repo = "git-recent";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qE6UNNuFfB2n3MuR+9gCRQCJKe0jOgW8ZwzlBZwvkrs=";
  };

  nativeBuildInputs = [ makeBinaryWrapper ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -D -m755 -t $out/bin git-recent

    wrapProgram $out/bin/git-recent \
      --prefix PATH : "${
        lib.makeBinPath [
          gitMinimal
          less
          util-linuxMinimal
        ]
      }"

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/paulirish/git-recent";
    description = "See your latest local git branches, formatted real fancy";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.jlesquembre ];
    mainProgram = "git-recent";
  };
})
