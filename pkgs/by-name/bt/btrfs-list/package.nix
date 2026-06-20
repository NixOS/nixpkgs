{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  btrfs-progs,
  coreutils,
  ncurses,
  perl,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "btrfs-list";
  version = "2.4";

  src = fetchFromGitHub {
    owner = "speed47";
    repo = "btrfs-list";
    rev = "v${finalAttrs.version}";
    hash = "sha256-K6/xFR4Qmr6ynH5rZfOTN8nkl99iqcJPmKPwtp9FYyc=";
  };

  buildInputs = [ perl ];

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    install -D -t $out/bin btrfs-list

    wrapProgram $out/bin/btrfs-list \
      --prefix PATH : ${
        lib.makeBinPath [
          coreutils # uses readlink
          ncurses # uses tput
          btrfs-progs
        ]
      }
  '';

  meta = {
    description = "Get a nice tree-style view of your btrfs subvolumes/snapshots, including their size, à la 'zfs list'";
    homepage = "https://github.com/speed47/btrfs-list";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ asymmetric ];
    mainProgram = "btrfs-list";
    platforms = lib.platforms.linux;
  };
})
