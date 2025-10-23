{
  bash,
  btrfs-progs,
  coreutils,
  fetchFromGitHub,
  gnugrep,
  lib,
  makeWrapper,
  stdenvNoCC,
  util-linuxMinimal,
}:
stdenvNoCC.mkDerivation rec {
  pname = "btrfs-snap";
  version = "1.7.3";
  src = fetchFromGitHub {
    owner = "jf647";
    repo = "btrfs-snap";
    tag = version;
    sha256 = "sha256-SDzLjgNRuR9XpmcYCD9T10MLS+//+pWFGDiTAb8NiLQ=";
  };
  buildInputs = [ bash ];
  nativeBuildInputs = [ makeWrapper ];
  dontConfigure = true;
  dontBuild = true;
  installPhase = ''
    mkdir -p $out/bin
    cp btrfs-snap $out/bin/
    wrapProgram $out/bin/btrfs-snap --prefix PATH : ${
      lib.makeBinPath [
        btrfs-progs # btrfs
        coreutils # cut, date, head, ls, mkdir, readlink, stat, tail, touch, test, [
        gnugrep # grep
        util-linuxMinimal # logger, mount
      ]
    }
  '';
  meta = with lib; {
    description = "Create and maintain the history of snapshots of btrfs filesystems";
    mainProgram = "btrfs-snap";
    homepage = "https://github.com/jf647/btrfs-snap";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ lionello ];
    platforms = platforms.linux;
  };
}
