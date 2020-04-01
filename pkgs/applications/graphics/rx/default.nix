{ stdenv, rustPlatform, fetchFromGitHub, makeWrapper
, cmake, pkg-config
, xorg ? null
, libGL ? null }:

with stdenv.lib;

rustPlatform.buildRustPackage rec {
  pname = "rx";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "cloudhead";
    repo = pname;
    rev = "v${version}";
    sha256 = "1pln65pqy39ijrld11d06klwzfhhzmrgdaxijpx9q7w9z66zmqb8";
  };

  cargoSha256 = "143a5x61s7ywk0ljqd10jkfvs6lrhlibkm2a9lw41wq13mgzb78j";

  nativeBuildInputs = [ cmake pkg-config makeWrapper ];

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
    homepage = "https://rx.cloudhead.io/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ minijackson filalex77 ];
    platforms = [ "x86_64-linux" ];
  };
}
