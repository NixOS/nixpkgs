{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  mlspp,
  nlohmann_json,
  openssl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libdave";
  version = "1.1.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "discord";
    repo = "libdave";
    tag = "v${finalAttrs.version}/cpp";
    hash = "sha256-ALDmtAjSkjnLDcmtpvcwiN7dPvpOgOTNFolr/H3SqsE=";
  };

  strictDeps = true;

  # src contains both the JavaScript and C++ library, so build the C++ library
  sourceRoot = "source/cpp";

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    mlspp
    openssl
    nlohmann_json
  ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DPERSISTENT_KEYS=OFF"
  ];

  postInstall = ''
    mkdir -p $out/lib/pkgconfig
    cat > $out/lib/pkgconfig/libdave.pc <<EOF
    prefix=$out
    libdir=\''${prefix}/lib
    includedir=\''${prefix}/include

    Name: libdave
    Description: Discord DAVE library
    Version: ${finalAttrs.version}
    Requires: openssl
    Libs: -L\''${libdir} -ldave
    Cflags: -I\''${includedir}
    EOF
  '';

  meta = {
    description = "Discord's End-to-End Audio Visual Encryption (DAVE) library";
    homepage = "https://github.com/discord/libdave";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ choco98 ];
    platforms = lib.platforms.linux;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
})
