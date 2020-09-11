{ stdenv
, fetchFromGitHub
, pkg-config
, curl
, mpv
, yajl
}:

stdenv.mkDerivation rec {
  pname = "jftui";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "Aanok";
    repo = pname;
    rev = "v${version}";
    sha256 = "1az737q5i24ylvkx4g3xlq8k48ni91nz5hhbif97g4nlhwl5cqb6";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    curl
    mpv
    yajl
  ];

  installPhase = ''
    install -Dm555 build/jftui $out/bin/jftui
  '';

  meta = with stdenv.lib; {
    description = "Jellyfin Terminal User Interface ";
    homepage = "https://github.com/Aanok/jftui";
    license = licenses.unlicense;
    maintainers = [ maintainers.nyanloutre ];
    platforms = platforms.linux;
  };
}
