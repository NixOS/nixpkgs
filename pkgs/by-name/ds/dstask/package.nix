{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  gitMinimal,
  installShellFiles,
}:

buildGoModule rec {
  pname = "dstask";
  version = "0.27";

  nativeBuildInputs = [
    installShellFiles
    # Git is required to run basic dstask commands, even for generating basic
    # completion scripts. It should be removed on next release because
    # https://github.com/naggie/dstask/pull/197 was merged.
    gitMinimal
  ];

  src = fetchFromGitHub {
    owner = "naggie";
    repo = pname;
    tag = version;
    hash = "sha256-bepG8QuOJnV2j1AWNSmfExx+Kpg0TIIhhuS54kftbQc=";
  };

  vendorHash = "sha256-/0ZCqL2dXgeeYlcBmkIOGcB+XJ0J2mSV5xOQJT3Dy9k=";
  doCheck = false;

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    # /!\ The convoluted workarrounds below will not be required anymore for
    # the next release as a fixed has been merged upstream :
    # https://github.com/naggie/dstask/pull/197

    # dstask requires that data is initialized, so we create an empty database:
    # https://github.com/naggie/dstask/issues/196
    export DSTASK_GIT_REPO=/tmp/.dstask

    # piping the output skips user validation (y/n) for the creation of the
    # database.
    $out/bin/dstask | cat

    installShellCompletion --cmd dstask \
      --bash <($out/bin/dstask bash-completion) \
      --fish <($out/bin/dstask fish-completion) \
      --zsh <($out/bin/dstask zsh-completion)
  '';

  # The ldflags reduce the executable size by stripping some debug stuff.
  # The other variables are set so that the output of dstask version shows the
  # git ref and the release version from github.
  # Ref <https://github.com/NixOS/nixpkgs/pull/87383#discussion_r432097657>
  ldflags = [
    "-w"
    "-s"
    "-X github.com/naggie/dstask.VERSION=${version}"
    "-X github.com/naggie/dstask.GIT_COMMIT=v${version}"
  ];

  meta = with lib; {
    description = "Command line todo list with super-reliable git sync";
    homepage = src.meta.homepage;
    license = licenses.mit;
    maintainers = with maintainers; [ stianlagstad ];
    platforms = platforms.linux;
  };
}
