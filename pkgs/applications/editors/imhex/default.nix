{ stdenv, gcc10Stdenv, cmake, pkgconfig, nlohmann_json, capstone, file, glfw3, glm, jsoncpp, llvm_9, openssl, python38, fetchFromGitHub }:
gcc10Stdenv.mkDerivation rec {
  pname = "imhex";
  version = "1.6.0-git"; # adds install target

  src = fetchFromGitHub {
    owner = "WerWolv";
    repo = "ImHex";
    #rev = "v${version}";
    rev = "e3b5a55eba51aaab1473abf4c2a40975ddd1e9fa";
    sha256 = "1nfq2yy21chldkg79r9nnb8n7g9fma6c9fnfy7yqgsl6y7iffxqw";
  };

  hardeningDisable = [ "format" ];

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ nlohmann_json capstone file glfw3 glm jsoncpp llvm_9 openssl python38 ];

  patches = [ ./default-db.patch ];

  postPatch = let
    patterns = fetchFromGitHub {
      name = "imhex-patterns";

      owner = "WerWolv";
      repo = "ImHex-Patterns";
      rev = "f5e5345aa6986ddaeb87a9648f5c539ae38a61a1";
      sha256 = "1dh77jc8dzc7xvzrabjrspn6lf3w8ab4lddvgpwaq6hd7lkdfpf6";
    };
  in ''
  substituteInPlace source/views/view_pattern.cpp --replace 'patterns' "${patterns}/patterns"
  substituteInPlace source/lang/preprocessor.cpp --replace 'include/' "${patterns}/includes/"
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/WerWolv/ImHex";
    description = "A hex editor for reverse engineers, programmers and people that value their eye sight when working at 3 AM";
    license = licenses.gpl2Only;
    platforms = platforms.all;
  };
}
