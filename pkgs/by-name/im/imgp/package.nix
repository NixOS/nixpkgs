{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "imgp";
  version = "2.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jarun";
    repo = "imgp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-yQ2BzOBn6Bl9ieZkREKsj1zLnoPcf0hZhZ90Za5kiKA=";
  };

  build-system = [ python3Packages.setuptools ];

  dependencies = [ python3Packages.pillow ];

  installFlags = [
    "DESTDIR=$(out)"
    "PREFIX="
  ];

  postInstall = ''
    install -Dm555 auto-completion/bash/imgp-completion.bash $out/share/bash-completion/completions/imgp.bash
    install -Dm555 auto-completion/fish/imgp.fish -t $out/share/fish/vendor_completions.d
    install -Dm555 auto-completion/zsh/_imgp -t $out/share/zsh/site-functions
  '';

  checkPhase = ''
    $out/bin/imgp --help
  '';

  meta = {
    description = "High-performance CLI batch image resizer & rotator";
    mainProgram = "imgp";
    homepage = "https://github.com/jarun/imgp";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ sikmir ];
  };
})
