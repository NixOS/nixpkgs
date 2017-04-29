{ stdenv, fetchFromGitHub, rustPlatform, cargo, libXinerama, libX11, xlibs, pkgconfig }:

rustPlatform.buildRustPackage rec {
  name = "wtftw-0.0pre20161001";
  src = fetchFromGitHub {
    owner = "kintaro";
    repo = "wtftw";
    rev = "b72a1bd24430a614d953d6ecf61732805277cc0c";
    sha256 = "1ajxkncqh4azyhmsdyk07r1kbhwv81vl1ix3w4iaz8cyln4gs0kp";
  };

  depsSha256 = "0z7h8ybh2db3xl8qxbzby5lncdaijixzmbn1j8a45lbky1xiix71";

  buildInputs = [ libXinerama libX11 pkgconfig ];
  libPath = stdenv.lib.makeLibraryPath [ libXinerama libX11 ];

  preInstall = ''
    cargo update
  '';

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/xsessions
    cp -p target/release/wtftw $out/bin/
    echo "[Desktop Entry]
      Name=wtftw
      Exec=/bin/wtftw
      Type=XSession
      DesktopName=wtftw" > $out/share/xsessions/wtftw.desktop
  '';

  meta = with stdenv.lib; {
    description = "A tiling window manager in Rust";
    homepage = https://github.com/Kintaro/wtftw;
    license = stdenv.lib.licenses.bsd3;
  };
}
