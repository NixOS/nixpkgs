{ stdenv, rustPlatform, fetchFromGitHub, makeWrapper
, cmake, pkgconfig
, xorg ? null
, libGL ? null }:

with stdenv.lib;

rustPlatform.buildRustPackage rec {
  pname = "rx";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "cloudhead";
    repo = pname;
    rev = "v${version}";
    sha256 = "1n5s7v2z13550gkqz7w6dw62jdy60wdi8w1lfa23609b4yhg4w94";
  };

  cargoSha256 = "077cs9bf7f3h5aschcv7pbbnpaq1rg79j7f6pnyrzkmn7gxzicg3";

  nativeBuildInputs = [ cmake pkgconfig makeWrapper ];

  buildInputs = optionals stdenv.isLinux
  (with xorg; [
    # glfw-sys dependencies:
    libX11 libXrandr libXinerama libXcursor libXi libXext
  ]);

  # FIXME: GLFW (X11) requires DISPLAY env variable for all tests
  doCheck = false;

  postInstall = optional stdenv.isLinux ''
    mkdir -p $out/share/applications
    cp $src/rx.desktop $out/share/applications
    wrapProgram $out/bin/rx --prefix LD_LIBRARY_PATH : ${libGL}/lib
  '';

  meta = {
    description = "Modern and extensible pixel editor implemented in Rust";
    homepage = "https://cloudhead.io/rx/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ minijackson filalex77 ];
    platforms = [ "x86_64-linux" ];
  };
}
