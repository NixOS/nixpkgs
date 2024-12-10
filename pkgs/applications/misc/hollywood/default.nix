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
  pygments,
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
  python3,
  wget,
  libcaca,
  newsboat,
  rsstail,
  w3m,
  ticker,
  tmux,
}:

stdenv.mkDerivation {
  pname = "hollywood";
  version = "1.22";

  src = fetchFromGitHub {
    owner = "dustinkirkland";
    repo = "hollywood";
    rev = "35275a68c37bbc39d8b2b0e4664a0c2f5451e5f6";
    sha256 = "sha256-faIm1uXERvIDZ6SK6uarVkWGNJskAroHgq5Cg7nUZc4=";
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
        pygments
        moreutils
        util-linux
        jp2a
        man
        mplayer
        openssh
        tree
        findutils
        ccze
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
    maintainers = [ lib.maintainers.anselmschueler ];
  };
}
