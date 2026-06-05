{
  lib,
  stdenv,
  fetchFromGitHub,
  unixtools,
  which,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "git-extras";
  version = "7.5.0";

  src = fetchFromGitHub {
    owner = "tj";
    repo = "git-extras";
    tag = finalAttrs.version;
    sha256 = "sha256-BmRLwdaP6Ic8cCtqPFaExEeqeE51l8JzzDmIfxz8Nvs=";
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
    changelog = "https://github.com/tj/git-extras/releases/tag/${finalAttrs.src.tag}";
    homepage = "https://github.com/tj/git-extras";
    description = "GIT utilities -- repo summary, repl, changelog population, author commit percentages and more";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
  };
})
