{ stdenv, lib, fetchurl, fetchFromGitHub
, gnumake, cmake, python3, pkg-config
, zlib, sqlite, fontconfig, gtk3, gcc9
, SDL2
}:

let
  src_egl = fetchurl {
    url = "https://raw.githubusercontent.com/KhronosGroup/EGL-Registry/649981109e263b737e7735933c90626c29a306f2/api/egl.xml";
    sha256 = "be5beb0bc9278d720730ca5f22df2d4a979a322075ee77593b49ace257953137";
  };

  src_khrplatform = fetchurl {
    url = "https://raw.githubusercontent.com/KhronosGroup/EGL-Registry/649981109e263b737e7735933c90626c29a306f2/api/KHR/khrplatform.h";
    sha256 = "e206a6931f98ffe1c5c7ece69c4f94bbe1c9279243f40cbe7782848a0d3fa2de";
  };

  src_gl = fetchurl {
    url = "https://raw.githubusercontent.com/KhronosGroup/OpenGL-Registry/e82287b71f66a88194f4a39e35fdac83dbf72707/xml/gl.xml";
    sha256 = "32517f41b05e0de322439f78ca8aec4bb9415ab3f93823f51b55cac93f684b4f";
  };

  src_glx = fetchurl {
    url = "https://raw.githubusercontent.com/KhronosGroup/OpenGL-Registry/e82287b71f66a88194f4a39e35fdac83dbf72707/xml/glx.xml";
    sha256 = "4f00f20e507c353e8cc7765cd414b659a53628a12c5c22459afdc7ddd0f620b6";
  };

  src_wgl = fetchurl {
    url = "https://raw.githubusercontent.com/KhronosGroup/OpenGL-Registry/e82287b71f66a88194f4a39e35fdac83dbf72707/xml/wgl.xml";
    sha256 = "4f36192884ce3e95b3a27d4ae1763fa57aba677fd31b421f8c496140f17538b6";
  };
in
stdenv.mkDerivation rec {
  pname = "OpenBoardView";
  version = "8.0";
  glad_path = "../src/glad";

  src = fetchFromGitHub {
    owner = "OpenBoardView";
    repo = pname;
    rev = "45edcee7e4c67cd90522d070431c920214002027";
    sha256 = "1wxr8c8zyxxp4addww6ml5a0pyknvb4lph1hd0lhzx4asjwjnz46";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    gcc9
    gnumake
    pkg-config
    python3
  ];

  buildInputs = [
    fontconfig
    gtk3
    (SDL2.override {
	withStatic = true;
	pulseaudioSupport = false;
	alsaSupport = false;
	dbusSupport = false;
	udevSupport = false;
	ibusSupport = false;
	fcitxSupport = false;
    }).dev
    sqlite
    zlib
  ];

  preBuild = ''
    cp ${src_egl} ${glad_path}/egl.xml
    cp ${src_gl}  ${glad_path}/gl.xml
    cp ${src_glx} ${glad_path}/glx.xml
    cp ${src_wgl} ${glad_path}/wgl.xml
    cp ${src_khrplatform} ${glad_path}/khrplatform.h
  '';

  meta = with lib; {
    description = "Linux SDL/ImGui edition software for viewing .brd files";
    homepage = "https://openboardview.org";
    license = licenses.mit;
    maintainers = with maintainers; [ felixsinger ];
    platforms = platforms.linux;
  };
}
