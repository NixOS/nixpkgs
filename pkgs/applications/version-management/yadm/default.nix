{ lib
, stdenv
, resholvePackage
, fetchFromGitHub
, git
, bash
, openssl
, gawk
/*
TODO: yadm can use git-crypt and transcrypt
but it does so in a way that resholve 0.6.0
can't yet do anything smart about. It looks
like these are for interactive use, so the
main impact should just be that users still
need both of these packages in their profile
to support their use in yadm.
*/
# , git-crypt
# , transcrypt
, j2cli
, esh
, gnupg
, coreutils
, gnutar
, installShellFiles
, runCommand
, yadm
}:

resholvePackage rec {
  pname = "yadm";
  version = "3.1.1";

  nativeBuildInputs = [ installShellFiles ];

  src = fetchFromGitHub {
    owner  = "TheLocehiliosan";
    repo   = "yadm";
    rev    = version;
    hash   = "sha256-bgiRBlqEjDq0gQ0+aUWpFDeE2piFX3Gy2gEAXgChAOk=";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dt $out/bin yadm
    runHook postInstall
  '';

  postInstall = ''
    installManPage yadm.1
    installShellCompletion --cmd yadm \
      --zsh completion/zsh/_yadm \
      --bash completion/bash/yadm
  '';

  solutions = {
    yadm = {
      scripts = [ "bin/yadm" ];
      interpreter = "${bash}/bin/sh";
      inputs = [
        git
        gnupg
        openssl
        gawk
        # see head comment
        # git-crypt
        # transcrypt
        j2cli
        esh
        bash
        coreutils
        gnutar
      ];
      fake = {
        external = if stdenv.isCygwin then [ ] else [ "cygpath" ];
      };
      fix = {
        "$GPG_PROGRAM" = [ "gpg" ];
        "$OPENSSL_PROGRAM" = [ "openssl" ];
        "$GIT_PROGRAM" = [ "git" ];
        "$AWK_PROGRAM" = [ "awk" ];
        # see head comment
        # "$GIT_CRYPT_PROGRAM" = [ "git-crypt" ];
        # "$TRANSCRYPT_PROGRAM" = [ "transcrypt" ];
        "$J2CLI_PROGRAM" = [ "j2" ];
        "$ESH_PROGRAM" = [ "esh" ];
        # not in nixpkgs (yet)
        # "$ENVTPL_PROGRAM" = [ "envtpl" ];
        # "$LSB_RELEASE_PROGRAM" = [ "lsb_release" ];
      };
      keep = {
        "$YADM_COMMAND" = true; # internal cmds
        "$template_cmd" = true; # dynamic, template-engine
        "$SHELL" = true; # probably user env? unsure
        "$hook_command" = true; # ~git hooks?
        "exec" = [ "$YADM_BOOTSTRAP" ]; # yadm bootstrap script

        # not in nixpkgs
        "$ENVTPL_PROGRAM" = true;
        "$LSB_RELEASE_PROGRAM" = true;
      };
      /*
      TODO: these should be dropped as fast as they can be dealt
            with properly in binlore and/or resholve.
      */
      execer = [
        "cannot:${j2cli}/bin/j2"
        "cannot:${esh}/bin/esh"
        "cannot:${git}/bin/git"
        "cannot:${gnupg}/bin/gpg"
      ];
    };
  };

  passthru.tests = {
    minimal = runCommand "${pname}-test" {} ''
      export HOME=$out
      ${yadm}/bin/yadm init
    '';
  };

  meta = {
    homepage = "https://github.com/TheLocehiliosan/yadm";
    description = "Yet Another Dotfiles Manager";
    longDescription = ''
      yadm is a dotfile management tool with 3 main features:
      * Manages files across systems using a single Git repository.
      * Provides a way to use alternate files on a specific OS or host.
      * Supplies a method of encrypting confidential data so it can safely be stored in your repository.
    '';
    changelog = "https://github.com/TheLocehiliosan/yadm/blob/${version}/CHANGES";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ abathur ];
    platforms = lib.platforms.unix;
  };
}
