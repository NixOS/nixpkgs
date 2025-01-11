{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rbenv";
  version = "1.3.0";

  nativeBuildInputs = [ installShellFiles ];

  src = fetchFromGitHub {
    owner = "rbenv";
    repo = "rbenv";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-AO0z9QtCGHwUr2ji28sbvQmCBDIfjAqbiac+HTH3N7Q=";
  };

  postPatch = ''
    patchShebangs src/configure
    pushd src
  '';

  installPhase = ''
    popd
    mkdir -p $out/bin
    mv libexec $out
    ln -s $out/libexec/rbenv $out/bin/rbenv

    installShellCompletion --zsh completions/_rbenv
    installShellCompletion --bash completions/rbenv.bash
  '';

  meta = {
    description = "Version manager tool for the Ruby programming language on Unix-like systems";
    longDescription = ''
      Use rbenv to pick a Ruby version for your application and guarantee that your development environment matches production.
      Put rbenv to work with Bundler for painless Ruby upgrades and bulletproof deployments.
    '';
    homepage = "https://github.com/rbenv/rbenv";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fzakaria ];
    mainProgram = "rbenv";
    platforms = lib.platforms.all;
  };
})
