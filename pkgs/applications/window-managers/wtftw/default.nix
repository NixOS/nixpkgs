{ stdenv, fetchgit, rustPlatform, cargo, libXinerama, libX11, xlibs, pkgconfig }:

with import <nixpkgs> { }; with rustPlatform; with xlibs; with stdenv;
#with rustPlatform;

#with rustPlatform;

buildRustPackage rec {
  name = "wtftw";
    src = fetchgit {
    url = https://github.com/Kintaro/wtftw;
    rev = "b84fdc04c100ed9d58fbcbd6af072ca553e810f4";
    sha256 = "09vm2jbdlpamnyg62kzrxcym2cnaz0vcqd3awyiabq507sax6l8l";
  };

  depsSha256 = "0d0mxbinkryg2rfqwq3p4l49xc7jhrp4bkvxmqz4lr413wvhhbmk";

  buildInputs = [ libXinerama libX11 pkgconfig ];
  libPath = lib.makeLibraryPath [ libXinerama libX11 ];

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
