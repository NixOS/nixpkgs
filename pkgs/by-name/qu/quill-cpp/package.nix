{
  cmake,
  fetchFromGitHub,
  lib,
  stdenv
}:

stdenv.mkDerivation rec {
  pname = "quill-cpp";
  version = "3.8.0";

  src = fetchFromGitHub {
    owner = "odygrd";
    repo = "quill";
    rev = "v${version}";
    sha256 = "sha256-8AS/1Yb8sHO/0wpjNZk/b18QtDM2tR7+DFnClFeMMPI=";
  };

  nativeBuildInputs = [
    cmake
  ];

  meta = with lib; {
    description = "A high-performance, cross-platform logging library";
    homepage = "https://github.com/odygrd/quill";
    license = licenses.mit;
    maintainers = [ maintainers.vaci ];
    platforms = platforms.all;
  };
}
