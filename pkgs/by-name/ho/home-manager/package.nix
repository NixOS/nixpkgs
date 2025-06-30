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
  unstableGitUpdater,
  runCommand,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "home-manager";
  version = "0-unstable-2025-06-22";

  src = fetchFromGitHub {
    name = "home-manager-source";
    owner = "nix-community";
    repo = "home-manager";
    rev = "7c35504839f915abec86a96435b881ead7eb6a2b";
    hash = "sha256-6WH0aRFay79r775RuTqUcnoZNm6A4uHxU1sbcNIk63s=";
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

  passthru = {
    updateScript = unstableGitUpdater {
      url = "https://github.com/nix-community/home-manager/";
    };
    tests = {
      /**
        This is a fixed-output derivation triggered by version bumps.
        The `outputHash` below would need to be updated manually from time
        to time. It records the hash of upstream's packaging file, i.e.

          $src/home-manager/default.nix

        The test will fail (by design) once this packaging file is changed
        upstream. The failure serves as an indicator that we should probably
        update the `package.nix` here in Nixpkgs as well.

        Once the changes from $src/home-manager/default.nix is incorporated
        here, we can update the `outputHash` below to silence the test
        failure.
      */
      upstreamPackaging =
        runCommand "home-manager-upstream-package-${finalAttrs.version}.nix"
          {
            outputHash = "sha256-O290IaZj50YwuCPtzyeAK9pMSseZpBwgXHG/lpVfzFY=";
            outputHashMode = "recursive";
          }
          ''
            echo "# upstream packaging code (for reference only)" > $out
            cat ${finalAttrs.src}/home-manager/default.nix >> $out
          '';
    };
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
