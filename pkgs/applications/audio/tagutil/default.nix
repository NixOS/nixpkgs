{ stdenv, lib, fetchFromGitHub
, pkg-config, cmake, libyaml
, jansson, libvorbis, taglib
, zlib
}:

stdenv.mkDerivation rec {
  pname = "tagutil";
  version = "3.1";

  src = fetchFromGitHub {
    owner = "kaworu";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-oY1aGl5CKVtpOfh8Wskio/huWYMiPuxWPqxlooTutcw=";
  };

  sourceRoot = "source/src";

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    libvorbis
    libyaml
    jansson
    taglib
    zlib
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace "-o aslr" ""
  '';

  meta = with lib; {
    description = "Scriptable music files tags tool and editor";
    homepage = "https://github.com/kaworu/tagutil";
    license = licenses.bsd2;
    maintainers = with maintainers; [ dan4ik605743 ];
    platforms = platforms.linux;
  };
}
