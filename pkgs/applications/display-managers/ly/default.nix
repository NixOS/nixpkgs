{ stdenv
, lib
, fetchFromGitHub
, linux-pam
, libxcb
, makeBinaryWrapper
, ncurses }:

stdenv.mkDerivation rec {
  pname = "ly";
  version = "0.6.0-unstable-2023-09-10";

  # The unstable version fixes the issue where configurations are ignored due
  # to a wrong array length during parsing the config file.
  # When the next stable version is released, we should use stable one instead.
  src = fetchFromGitHub {
    owner = "fairyglade";
    repo = "ly";
    rev = "4ee2b3ecc73882cfecdbe2162d4fece406a110e7";
    hash = "sha256-puv8QCM6Vt/9WmJd9CLQIhVl7r1aVO64zopIrgMPGhw=";
    fetchSubmodules = true;
  };

  hardeningDisable = [ "all" ];
  nativeBuildInputs = [ makeBinaryWrapper ];
  buildInputs = [ libxcb linux-pam ];

  installPhase = ''
    mkdir -p $out/bin
    cp bin/ly $out/bin
  '';

  postFixup = ''
    wrapProgram $out/bin/ly --prefix PATH : ${lib.makeBinPath [ncurses]}
  '';

  meta = with lib; {
    description = "TUI display manager";
    license = licenses.wtfpl;
    homepage = "https://github.com/fairyglade/ly";
    maintainers = [ maintainers.vidister ];
    platforms = platforms.linux;
    mainProgram = "ly";
  };
}
