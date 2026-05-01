{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  doxygen,
  libwebp,
  curl,
  cli11,
  python3,
  pkg-config,
  cairo,
  gtk3,
  catch2_3,
  backward-cpp,
}:

let
  dlib = fetchFromGitHub {
    owner = "davisking";
    repo = "dlib";
    tag = "v20.0";
    hash = "sha256-VTX7s0p2AzlvPUsSMXwZiij+UY9g2y+a1YIge9bi0sw=";
  };

  thread-pool = fetchFromGitHub {
    owner = "bshoshany";
    repo = "thread-pool";
    tag = "v5.0.0";
    hash = "sha256-1TTpt6u3NVIMSExl0ttuwH2owQCetujolnR/t8hDMh0=";
  };

  gcem = fetchFromGitHub {
    owner = "klytje";
    repo = "gcem";
    rev = "c5464969d373ed0a763c3562656798d1cc00687f";
    hash = "sha256-bnWakLHl/afpeFm6S32ku0IkniyIs8X+LE1NmV6p0ho=";
  };

  elements = fetchFromGitHub {
    owner = "cycfi";
    repo = "elements";
    rev = "71ecd1f4ebc76967c6812b1872db639784e40a2d";
    hash = "sha256-F3Dv+QboXfOSaXpbdOeWPtOC8orWGZc8ZBFho/X8Ky8=";
  };

  nfd = fetchFromGitHub {
    owner = "btzy";
    repo = "nativefiledialog-extended";
    tag = "v1.2.1";
    hash = "sha256-GwT42lMZAAKSJpUJE6MYOpSLKUD5o9nSe9lcsoeXgJY=";
  };

  asio = fetchFromGitHub {
    owner = "chriskohlhoff";
    repo = "asio";
    tag = "asio-1-29-0";
    hash = "sha256-5WSrMe9n+8i/ZyvCsa4MMBguYbSz+7FwH0Z5JfHtRGM=";
  };

  cycfi_infra = fetchFromGitHub {
    owner = "cycfi";
    repo = "infra";
    rev = "2dff97a4b107eced78e426152f5001a2331cb1cf";
    hash = "sha256-NmoPYhfsrC5oWFjJ9Ol83sR8aIkyQr6UpaCeZpW58PI=";
    fetchSubmodules = true;
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "ausaxs";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "AUSAXS";
    repo = "AUSAXS";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vTuQsg76p0WHPadwqBdDGBSNgNmr5TxuwlNj47P+sa8=";
  };

  patches = [ ./cmake-no-fetchcontent.patch ];

  postPatch = ''
    cp --recursive --no-preserve=mode ${dlib} dlib
    cp --recursive --no-preserve=mode ${thread-pool} thread_pool
    cp --recursive --no-preserve=mode ${gcem} gcem
    cp --recursive --no-preserve=mode ${nfd} nfd
    cp --recursive --no-preserve=mode ${elements} elements
    cp --recursive --no-preserve=mode ${asio} asio
    cp --recursive --no-preserve=mode ${cycfi_infra} cycfi_infra
    patch -p1 -d elements < ${./elements-cmake-no-fetchcontent.patch}
    substituteInPlace CMakeLists.txt \
      --replace-fail "-mavx" "${
        lib.optionalString (stdenv.hostPlatform.isx86_64 && stdenv.hostPlatform.isLinux) "-msse3"
      }"
  '';

  nativeBuildInputs = [
    cmake
    doxygen
    python3
    pkg-config
  ];

  buildInputs = [
    backward-cpp
    catch2_3
    curl
    cli11
    cairo
    libwebp
    gtk3
  ];

  cmakeFlags = [
    (lib.cmakeBool "GUI" true)
    (lib.cmakeBool "USE_SYSTEM_CATCH" true)
    (lib.cmakeBool "USE_SYSTEM_CLI11" true)
    (lib.cmakeBool "USE_SYSTEM_BACKWARD" true)
  ];

  postInstall = ''
    cp --recursive lib/* $out/lib/
    cp --recursive bin $out/bin
    cp --recursive ../scripts $out/bin/scripts
  '';

  meta = {
    description = "Small-angle X-ray scattering framework";
    homepage = "https://github.com/AUSAXS/AUSAXS";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ kyehn ];
    platforms = lib.platforms.unix;
  };
})
