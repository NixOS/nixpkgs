{
  lib,
  stdenv,
  fetchFromGitHub,
  makeBinaryWrapper,
  bash,
  gitMinimal,
  delta,
  fzf,
  coreutils,
  gnugrep,
  gnused,
  gawk,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "git-recent";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "paulirish";
    repo = "git-recent";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ScgzMG40uR9+4cjTIHwmefSoAxVNELNx8fDVXGFl8rU=";
  };

  nativeBuildInputs = [ makeBinaryWrapper ];
  buildInputs = [ bash ];

  __structuredAttrs = true;
  strictDeps = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin git-recent

    patchShebangs $out/bin/git-recent

    # git-recent treats delta as optional and probes PATH at runtime
    # (`delta || diff-so-fancy`), so keep it after the user's PATH to prefer
    # any user-provided diff pager.
    wrapProgram $out/bin/git-recent \
      --prefix PATH : "${
        lib.makeBinPath [
          gitMinimal
          fzf
          coreutils
          gnugrep
          gnused
          gawk
        ]
      }" \
      --suffix PATH : "${lib.makeBinPath [ delta ]}"

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
