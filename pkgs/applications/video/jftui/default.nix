{ stdenv
, fetchFromGitHub
, pkg-config
, curl
, mpv
, yajl
}:

stdenv.mkDerivation rec {
  pname = "jftui";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "Aanok";
    repo = pname;
    rev = "v${version}";
    sha256 = "0riwqfh5lyjg7as75kyx7jw6zq4gikbglhv8s05y7pzgsc9xy75j";
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
