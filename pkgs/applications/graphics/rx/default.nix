{ stdenv, rustPlatform, fetchFromGitHub, makeWrapper
, cmake, pkgconfig
, xorg ? null
, vulkan-loader ? null }:

with stdenv.lib;

rustPlatform.buildRustPackage rec {
  pname = "rx";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "cloudhead";
    repo = pname;
    rev = "v${version}";
    sha256 = "0mhpq9x54d884ydmfv1358sgc4jc7bghfx2y0k7p879hyyxr52v1";
  };

  cargoSha256 = "0fnrgijfkvapj1yyy9grnqh2vkciisf029af0gfwyzsxzdi62gg5";

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
    wrapProgram $out/bin/rx --prefix LD_LIBRARY_PATH : ${vulkan-loader}/lib
  '';

  meta = {
    description = "Modern and extensible pixel editor implemented in Rust";
    homepage = "https://cloudhead.io/rx/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ minijackson filalex77 ];
    platforms = [ "x86_64-linux" ];
  };
}
