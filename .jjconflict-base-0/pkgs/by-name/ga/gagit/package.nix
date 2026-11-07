{
  lib,
  resholve,
  fetchzip,
  bash,
  coreutils,
  git,
  meson,
  ninja,
}:

resholve.mkDerivation (finalAttrs: {
  pname = "gagit";
  version = "4";

  src = fetchzip {
    url = "https://gitweb.gentoo.org/proj/gagit.git/snapshot/gagit-${finalAttrs.version}.tar.gz";
    hash = "sha256-V8qLZu2dpbUbpHZ5AH7Zr6HcgujjnWw9DFLF4K57RCc=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  solutions = {
    default = {
      scripts = [ "bin/gagit" ];
      interpreter = lib.getExe bash;
      inputs = [
        coreutils
        git
      ];
      keep = {
        # Based on $EDITOR and --editor, defaulting to vim.
        # Providing it is up to the user.
        "$editor" = true;
      };
      execer = [
        # Resholve can't handle git yet. I don't see any subexec in the script.
        "cannot:${lib.getExe git}"
      ];
    };
  };

  nativeBuildInputs = [
    meson
    ninja
  ];

  nativeCheckInputs = [
    git
  ];

  doCheck = true;

  meta = {
    description = "Gentoo AGit workflow tool";
    homepage = "https://gitweb.gentoo.org/proj/gagit.git/";
    license = lib.licenses.gpl2Plus;
    longDescription = ''
      GAGit is yet another AGit workflow tool, dedicated to pushing to the
      Gentoo Codeberg mirrors. The goal is to:

        1. Automatically figure out the correct remote and target branch,
           accounting for different setups (such as GURU using dev).
        2. Use the editor to provide the initial pull request description,
        respecting the pull request template.
        3. Set upstream for the branch to make PR updates easy.
    '';
    maintainers = with lib.maintainers; [ fgaz ];
    mainProgram = "gagit";
    platforms = lib.platforms.all;
  };
})
