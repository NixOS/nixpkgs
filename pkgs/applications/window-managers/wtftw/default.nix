{ stdenv, fetchFromGitHub, rustPlatform, cargo, libXinerama, libX11, xlibs, pkgconfig }:

rustPlatform.buildRustPackage rec {
  name = "wtftw-0.0pre20170921";
  src = fetchFromGitHub {
    owner = "kintaro";
    repo = "wtftw";
    rev = "13712d4c051938520b90b6639d4ff813f6fe5f48";
    sha256 = "1r74nhcwiy2rmifzjhdal3jcqz4jz48nfvhdyw4gasa6nxp3msdl";
  };

  cargoSha256 = "0z92ml84b5652zgwzn08a8vvxksaa54jql66sfpdz1mvjwhgdmvn";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libXinerama libX11 ];
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
      Exec=$out/bin/wtftw
      Type=XSession
      DesktopName=wtftw" > $out/share/xsessions/wtftw.desktop
  '';

  meta = with stdenv.lib; {
    broken = true;
    description = "A tiling window manager in Rust";
    homepage = https://github.com/Kintaro/wtftw;
    license = stdenv.lib.licenses.bsd3;
  };
}
