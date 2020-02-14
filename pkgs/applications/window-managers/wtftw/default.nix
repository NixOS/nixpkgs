{ stdenv, fetchFromGitHub, rustPlatform, libXinerama, libX11, pkgconfig }:

rustPlatform.buildRustPackage {
  name = "wtftw-0.0pre20170921";
  src = fetchFromGitHub {
    owner = "kintaro";
    repo = "wtftw";
    rev = "13712d4c051938520b90b6639d4ff813f6fe5f48";
    sha256 = "1r74nhcwiy2rmifzjhdal3jcqz4jz48nfvhdyw4gasa6nxp3msdl";
  };

  # Delete this on next update; see #79975 for details
  legacyCargoFetcher = true;

  cargoSha256 = "18lb24k71sndklbwwhbv8jglj2d4y9mdk07l60wsvn5m2jbnpckk";

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
