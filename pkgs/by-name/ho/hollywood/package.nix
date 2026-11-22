{
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  lib,
  coreutils,
  apg,
  atop,
  bmon,
  cmatrix,
  python3Packages,
  moreutils,
  util-linux,
  jp2a,
  man,
  mplayer,
  openssh,
  tree,
  mlocate,
  findutils,
  ccze,
  ncurses,
  tmux,
  pv,
  bat,
  figlet,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hollywood";
  version = "1.26";

  src = fetchFromGitHub {
    owner = "dustinkirkland";
    repo = "hollywood";
    rev = "${finalAttrs.version}";
    hash = "sha256-8e+XyMZ9xPkMKYt+vgmdPJZqjQDj0yfVmycbdHl6BrA=";
  };

  nativeBuildInputs = [ makeWrapper ];

  patches = [ ./nixos-paths.patch ];
  postPatch = ''
    rm lib/hollywood/speedometer
    rm bin/wallstreet
    rm -r lib/wallstreet
  '';

  dontBuild = true;

  installPhase =
    let
      pathDeps = [
        tmux
        coreutils
        ncurses
        jp2a
        mlocate
        apg
        atop
        bmon
        cmatrix
        python3Packages.pygments
        moreutils
        util-linux
        man
        mplayer
        openssh
        tree
        findutils
        ccze
        pv
        bat
        figlet
      ];
    in
    ''
      runHook preInstall

      mkdir -p $out
      cp -r bin $out/bin
      cp -r lib $out/lib
      cp -r share $out/share
      wrapProgram $out/bin/hollywood --prefix PATH : ${lib.makeBinPath pathDeps}

      runHook postInstall
    '';

  meta = {
    description = "Fill your console with Hollywood melodrama technobabble";
    mainProgram = "hollywood";
    homepage = "https://a.hollywood.computer/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ olduser101 ];
  };
})
