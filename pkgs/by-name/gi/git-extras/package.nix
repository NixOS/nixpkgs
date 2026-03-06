{
  lib,
  stdenv,
  fetchFromGitHub,
  unixtools,
  which,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "git-extras";
  version = "7.4.0";

  src = fetchFromGitHub {
    owner = "tj";
    repo = "git-extras";
    rev = finalAttrs.version;
    sha256 = "sha256-xxBmOAJgoVR+K3gEM5KFKyWenwFnar+zF26HnTG5vuw=";
  };

  postPatch = ''
    patchShebangs check_dependencies.sh
  '';

  nativeBuildInputs = [
    unixtools.column
    which
  ];

  dontBuild = true;

  installFlags = [
    "PREFIX=${placeholder "out"}"
    "SYSCONFDIR=${placeholder "out"}/share"
  ];

  postInstall = ''
    # bash completion is already handled by make install
    install -D etc/git-extras-completion.zsh $out/share/zsh/site-functions/_git_extras
  '';

  meta = {
    homepage = "https://github.com/tj/git-extras";
    description = "GIT utilities -- repo summary, repl, changelog population, author commit percentages and more";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
  };
})
