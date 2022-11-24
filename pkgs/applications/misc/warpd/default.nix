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
  version = "1.3.4";

  src = fetchFromGitHub {
    owner = "rvaiya";
    repo = "warpd";
    rev = "v${version}";
    sha256 = "sha256-aNv2/+tREvKlpTAsbvmFxkXzONNt73/061i4E3fPFBM=";
    leaveDotGit = true;
  };

  nativeBuildInputs = [ git ];

  buildInputs =  if waylandSupport then [
    cairo
    libxkbcommon
    wayland
  ] else [
    libXi
    libXinerama
    libXft
    libXfixes
    libXtst
    libX11
    libXext
  ];

  makeFlags = [ "PREFIX=$(out)" ] ++ lib.optionals waylandSupport [ "PLATFORM=wayland" ];

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
