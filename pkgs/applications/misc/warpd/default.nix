{ lib
, stdenv
, fetchFromGitHub
, git
, libXi
, libXinerama
, libXft
, libXfixes
, libXtst
, libX11
, libXext
, waylandSupport ? false, cairo, libxkbcommon, wayland
}:

stdenv.mkDerivation rec {
  pname = "warpd";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "rvaiya";
    repo = "warpd";
    rev = "v${version}";
    sha256 = "AR/uLgNX1VLPEcfUd8cnplMiaoEJlUxQ55Fst62RnbI=";
    leaveDotGit = true;
  };

  nativeBuildInputs = [ git ];

  buildInputs =  [
    libXi
    libXinerama
    libXft
    libXfixes
    libXtst
    libX11
    libXext
  ] ++ lib.optionals waylandSupport [
    cairo
    libxkbcommon
    wayland
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace '-m644' '-Dm644' \
      --replace '-m755' '-Dm755' \
      --replace 'warpd.1.gz $(DESTDIR)' 'warpd.1.gz -t $(DESTDIR)' \
      --replace 'bin/warpd $(DESTDIR)' 'bin/warpd -t $(DESTDIR)'
  '';

  meta = with lib; {
    description = "A modal keyboard driven interface for mouse manipulation.";
    homepage = "https://github.com/rvaiya/warpd";
    changelog = "https://github.com/rvaiya/warpd/blob/${src.rev}/CHANGELOG.md";
    maintainers = with maintainers; [ hhydraa ];
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
