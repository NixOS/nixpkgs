{
  fetchFromGitHub,
  git,
  lib,
  makeWrapper,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "git-now";
  version = "0.1.1.0";

  src = fetchFromGitHub {
    owner = "iwata";
    repo = "git-now";
    rev = "v${version}";
    hash = "sha256-r1Xl9i2SXkaxVBjChdsnqgsex8f+AyVsPbBMwLHOVpM=";
  };

  shFlagsSrc = fetchFromGitHub {
    owner = "nvie";
    repo = "shFlags";
    rev = "2fb06af13de884e9680f14a00c82e52a67c867f1";
    hash = "sha256-Xp+2MOIRpe06DoD4+QV8pE+oEdgFQB7/J0jgfV/6WqQ=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/git-now

    # Copy shFlags library
    cp $shFlagsSrc/src/shflags $out/share/git-now/

    # Copy common file and shFlags symlink to bin (where scripts expect them)
    cp gitnow-common $out/bin/
    ln -s $out/share/git-now/shflags $out/bin/gitnow-shFlags

    # Copy main scripts
    cp git-now $out/bin/
    cp git-now-add $out/bin/
    cp git-now-grep $out/bin/
    cp git-now-push $out/bin/
    cp git-now-rebase $out/bin/

    # Make main script executable (subcommands are sourced, not executed directly)
    chmod +x $out/bin/git-now

    # Only wrap the main git-now script - subcommands are sourced by it
    wrapProgram "$out/bin/git-now" \
      --prefix PATH : "${lib.makeBinPath [ git ]}"

    runHook postInstall
  '';

  meta = {
    description = "Git command for light and temporary commits";
    homepage = "https://github.com/iwata/git-now";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ ryoppippi ];
    platforms = lib.platforms.unix;
    mainProgram = "git-now";
  };
}
