{ stdenv, rustPlatform, fetchFromGitHub, makeWrapper
, cmake, pkgconfig
, xorg ? null
, libGL ? null }:

with stdenv.lib;

rustPlatform.buildRustPackage rec {
  pname = "rx";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "cloudhead";
    repo = pname;
    rev = "v${version}";
    sha256 = "1byaxbhd3q49473kcdd52rvn3xq7bmy8bdx3pz0jiw96bclzhcgq";
  };

  cargoSha256 = "173jfjvdag97f6jvfg366hjk9v3cz301cbzpcahy51rbf1cip1w1";

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
