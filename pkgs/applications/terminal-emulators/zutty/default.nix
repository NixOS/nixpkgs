{ lib
, stdenv
, fetchFromGitHub
, wafHook
, python3
, pkg-config
, freetype
, libglvnd
, libXmu
, fontmiscmisc
}:

stdenv.mkDerivation rec {
  pname = "zutty";
  version = "0.11";

  src = fetchFromGitHub {
    owner = "tomszilagyi";
    repo = pname;
    rev = version;
    hash = "sha256-OUBGNLasFo1EmlpDE31CVu7u7B+cWcCB7ASqfU56i4k=";
  };

  nativeBuildInputs = [
    wafHook
    python3
    pkg-config
  ];

  buildInputs = [
    freetype
    libglvnd
    libXmu
  ];

  postPatch = ''
    substituteInPlace src/options.h \
      --replace '/usr/share/fonts' '${fontmiscmisc}/lib/X11/fonts/misc'
  '';

  postInstall = ''
    install -Dm644 -t $out/share/doc/${pname} doc/*
  '';

  meta = with lib; {
    homepage = "https://tomscii.sig7.se/zutty/";
    description = "A high-end terminal for low-end systems";
    longDescription = ''
      Zutty is a terminal emulator for the X Window System, functionally
      similar to several other X terminal emulators such as xterm, rxvt and
      countless others. It is also similar to other, much more modern,
      GPU-accelerated terminal emulators such as Alacritty and Kitty. What
      really sets Zutty apart is its radically simple, yet extremely efficient
      rendering implementation, coupled with a sufficiently complete feature
      set to make it useful for a wide range of users. Zutty offers high
      throughput with low latency, and strives to conform to relevant
      (published or de-facto) standards.
    '';
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ gravndal ];
    platforms = platforms.linux;
  };
}
