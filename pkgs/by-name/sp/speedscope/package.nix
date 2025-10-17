{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  versionCheckHook,
}:

buildNpmPackage rec {
  pname = "speedscope";
  version = "1.23.1";

  src = fetchFromGitHub {
    owner = "jlfwong";
    repo = "speedscope";
    tag = "v${version}";
    hash = "sha256-PIyx4ceihTSLRDP5MW3n6edtYNFOnx8Uo7qUWW7LTs8=";

    # scripts/prepack.sh wants to extract the git commit from .git
    # We don't want to keep .git for reproducibility reasons, so save the commit
    # to a file and patch the script.
    leaveDotGit = true;
    postFetch = ''
      ( cd $out; git rev-parse HEAD > COMMIT )
      rm -rf $out/.git
    '';
  };

  npmDepsHash = "sha256-xpFrkKAaFbVE1zJ/haibQte4HjUWmeBR8BVjZuSoyjI=";

  patches = [
    ./fix-shebang.patch
  ];

  postConfigure = ''
    patchShebangs scripts
  '';

  dontNpmBuild = true;

  postFixup = ''
    # Remove some dangling symlinks
    rm $out/lib/node_modules/speedscope/node_modules/.bin/sshpk*
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  meta = {
    description = "Fast and interactive web-based viewer for performance profiles";
    homepage = "https://github.com/jlfwong/speedscope";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "speedscope";
    maintainers = with lib.maintainers; [ thomasjm ];
  };
}
