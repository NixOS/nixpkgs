{
  lib,
  stdenv,
  fetchFromGitHub,
  docutils,
  makeWrapper,
  gnupg,
  curl,
  rsync,
  coreutils,
  gawk,
  gnused,
  gnugrep,
}:

stdenv.mkDerivation rec {
  pname = "git-remote-gcrypt";
  version = "1.5";
  rev = version;

  src = fetchFromGitHub {
    inherit rev;
    owner = "spwhitton";
    repo = "git-remote-gcrypt";
    sha256 = "sha256-uy6s3YQwY/aZmQoW/qe1YrSlfNHyDTXBFxB6fPGiPNQ=";
  };

  outputs = [
    "out"
    "man"
  ];

  nativeBuildInputs = [
    docutils
    makeWrapper
  ];

  installPhase = ''
    prefix="$out" ./install.sh
    wrapProgram "$out/bin/git-remote-gcrypt" \
      --prefix PATH ":" "${
        lib.makeBinPath [
          gnupg
          curl
          rsync
          coreutils
          gawk
          gnused
          gnugrep
        ]
      }"
  '';

  meta = with lib; {
    homepage = "https://spwhitton.name/tech/code/git-remote-gcrypt";
    description = "Git remote helper for GPG-encrypted remotes";
    license = licenses.gpl3;
    maintainers = with maintainers; [
      ellis
      montag451
    ];
    platforms = platforms.unix;
    mainProgram = "git-remote-gcrypt";
  };
}
