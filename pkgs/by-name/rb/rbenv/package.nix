{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rbenv";
  version = "1.2.0";

  nativeBuildInputs = [ installShellFiles ];

  src = fetchFromGitHub {
    owner = "rbenv";
    repo = "rbenv";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-m/Yy5EK8pLTBFcsgKCrNvQrPFFIlYklXXZbjN4Nmm9c=";
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

    installShellCompletion completions/rbenv.{bash,zsh}
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
