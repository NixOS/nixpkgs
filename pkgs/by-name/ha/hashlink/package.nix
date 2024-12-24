{ stdenv
, lib
, fetchFromGitHub
, libGL
, libGLU
, libpng
, libjpeg_turbo
, libuv
, libvorbis
, mbedtls_2
, openal
, pcre
, SDL2
, sqlite
, getconf
}:

stdenv.mkDerivation rec {
  pname = "hashlink";
  version = "1.14";

  src = fetchFromGitHub {
    owner = "HaxeFoundation";
    repo = "hashlink";
    rev = version;
    sha256 = "sha256-rXw56zoFpLMzz8U3RHWGBF0dUFCUTjXShUEhzp2Qc5g=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  buildInputs = [
    libGL
    libGLU
    libjpeg_turbo
    libpng
    libuv
    libvorbis
    mbedtls_2
    openal
    pcre
    SDL2
    sqlite
  ];

  nativeBuildInputs = [ getconf ];

  # append default installPhase with library install for haxe
  postInstall = let
    haxelibPath = "$out/lib/haxe/hashlink/${lib.replaceStrings [ "." ] [ "," ] version}";
  in ''
    mkdir -p "${haxelibPath}"
    echo -n "${version}" > "${haxelibPath}/../.current"
    cp -r other/haxelib/* "${haxelibPath}"
  '';

  postFixup = lib.optionalString stdenv.hostPlatform.isDarwin ''
    install_name_tool -change libhl.dylib $out/lib/libhl.dylib $out/bin/hl
  '';

  meta = with lib; {
    description = "Virtual machine for Haxe";
    mainProgram = "hl";
    homepage = "https://hashlink.haxe.org/";
    license = licenses.mit;
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
    maintainers = with maintainers; [ iblech locallycompact logo ];
  };
}
