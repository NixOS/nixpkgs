{
  lib,
  bash,
  coreutils,
  fetchFromGitHub,
  findutils,
  gettext,
  gnused,
  inetutils,
  installShellFiles,
  jq,
  less,
  ncurses,
  nixos-option,
  stdenvNoCC,
  unixtools,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "home-manager";
<<<<<<< HEAD
  version = "0-unstable-2025-12-25";
=======
  version = "0-unstable-2025-11-27";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    name = "home-manager-source";
    owner = "nix-community";
    repo = "home-manager";
<<<<<<< HEAD
    rev = "91cdb0e2d574c64fae80d221f4bf09d5592e9ec2";
    hash = "sha256-GKO35onS711ThCxwWcfuvbIBKXwriahGqs+WZuJ3v9E=";
=======
    rev = "86ff0ef506c209bb397849706e85cc3a913cb577";
    hash = "sha256-bO7FN/bF6gG7TlZpKAZjO3VvfsLaPFkefeUfJJ7F/7w=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    gettext
    installShellFiles
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -D -m755 home-manager/home-manager $out/bin/home-manager
    install -D -m755 lib/bash/home-manager.sh $out/share/bash/home-manager.sh

    installShellCompletion --cmd home-manager \
      --bash home-manager/completion.bash \
      --fish home-manager/completion.fish \
      --zsh home-manager/completion.zsh

    for pofile in home-manager/po/*.po; do
      lang="''${pofile##*/}"
      lang="''${lang%%.*}"
      mkdir -p "$out/share/locale/$lang/LC_MESSAGES"
      msgfmt -o "$out/share/locale/$lang/LC_MESSAGES/home-manager.mo" "$pofile"
    done

    runHook postInstall
  '';

  postFixup = ''
    substituteInPlace $out/bin/home-manager \
      --subst-var-by bash "${bash}" \
      --subst-var-by DEP_PATH "${
        lib.makeBinPath [
          coreutils
          findutils
          gettext
          gnused
          jq
          less
          ncurses
          nixos-option
          inetutils # for `hostname`
        ]
      }" \
      --subst-var-by HOME_MANAGER_LIB "$out/share/bash/home-manager.sh" \
      --subst-var-by HOME_MANAGER_PATH "${finalAttrs.src}" \
      --subst-var-by OUT "$out"
  '';

  passthru.updateScript = unstableGitUpdater {
    url = "https://github.com/nix-community/home-manager/";
  };

  meta = {
    homepage = "https://nix-community.github.io/home-manager/";
    description = "Nix-based user environment configurator";
    longDescription = ''
      The Home-Manager project provides a basic system for managing a user
      environment using the Nix package manager together with the Nix libraries
      found in Nixpkgs. It allows declarative configuration of user specific
      (non global) packages and dotfiles.
    '';
    license = lib.licenses.mit;
    mainProgram = "home-manager";
    maintainers = with lib.maintainers; [ bryango ];
    platforms = lib.platforms.unix;
  };
})
