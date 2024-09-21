{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, fftwFloat
, alsa-lib
, zlib
, wavpack
, wxGTK32
, udev
, jackaudioSupport ? false
, libjack2
, imagemagick
, libicns
, yaml-cpp
, makeWrapper
, Cocoa
, includeDemo ? true
}:

stdenv.mkDerivation rec {
  pname = "grandorgue";
  version = "3.15.1-1";

  src = fetchFromGitHub {
    owner = "GrandOrgue";
    repo = "grandorgue";
    rev = version;
    fetchSubmodules = true;
    hash = "sha256-5uAA878OBc04PkUgCwoRtc6lIASivq3YcfFffTae6uM=";
  };

  postPatch = ''
    substituteInPlace resources/CMakeLists.txt \
      --replace \
        "iconutil -c icns \''${GENERATED_ICONS_DIR}" \
        "png2icns \''${GENERATED_ICONS_DIR}/../GrandOrgue.icns \''${GENERATED_ICONS_DIR}/*{16,32,128,256,512,1024}.png" \
  '';

  nativeBuildInputs = [ cmake pkg-config imagemagick libicns makeWrapper ];

  buildInputs = [ fftwFloat zlib wavpack wxGTK32 yaml-cpp ]
    ++ lib.optionals stdenv.isLinux [ alsa-lib udev ]
    ++ lib.optionals stdenv.isDarwin [ Cocoa ]
    ++ lib.optional jackaudioSupport libjack2;

  cmakeFlags = lib.optionals (!jackaudioSupport) [
    "-DRTAUDIO_USE_JACK=OFF"
    "-DRTMIDI_USE_JACK=OFF"
    "-DGO_USE_JACK=OFF"
    "-DINSTALL_DEPEND=OFF"
  ] ++ lib.optional (!includeDemo) "-DINSTALL_DEMO=OFF";

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isDarwin "-DTARGET_OS_IPHONE=0";

  postInstall = lib.optionalString stdenv.isDarwin ''
    mkdir -p $out/{Applications,bin,lib}
    mv $out/GrandOrgue.app $out/Applications/
    for lib in $out/Applications/GrandOrgue.app/Contents/Frameworks/lib*; do
      ln -s $lib $out/lib/
    done
    makeWrapper $out/{Applications/GrandOrgue.app/Contents/MacOS,bin}/GrandOrgue
  '';

  meta = {
    description = "Virtual Pipe Organ Software";
    homepage = "https://github.com/GrandOrgue/grandorgue";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.puzzlewolf ];
    mainProgram = "GrandOrgue";
  };
}
