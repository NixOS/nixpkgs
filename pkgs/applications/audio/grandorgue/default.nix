{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, fftwFloat, alsa-lib
, zlib, wavpack, wxGTK32, udev, jackaudioSupport ? false, libjack2
, imagemagick, libicns, makeWrapper, Cocoa
, includeDemo ? true }:

stdenv.mkDerivation rec {
  pname = "grandorgue";
  version = "3.9.0-1";

  src = fetchFromGitHub {
    owner = "GrandOrgue";
    repo = pname;
    rev = version;
    fetchSubmodules = true;
    sha256 = "sha256-+LWEjoke7f+6f4K4jO9nCG88Mdg9C49+v3FboM9/NkU=";
  };

  postPatch = ''
    substituteInPlace resources/CMakeLists.txt \
      --replace \
        "iconutil -c icns \''${GENERATED_ICONS_DIR}" \
        "png2icns \''${GENERATED_ICONS_DIR}/../GrandOrgue.icns \''${GENERATED_ICONS_DIR}/*{16,32,128,256,512,1024}.png" \
  '';

  nativeBuildInputs = [ cmake pkg-config imagemagick libicns makeWrapper ];

  buildInputs = [ fftwFloat zlib wavpack wxGTK32 ]
    ++ lib.optionals stdenv.isLinux [ alsa-lib udev ]
    ++ lib.optionals stdenv.isDarwin [ Cocoa ]
    ++ lib.optional jackaudioSupport libjack2;

  cmakeFlags = lib.optionals (!jackaudioSupport) [
    "-DRTAUDIO_USE_JACK=OFF"
    "-DRTMIDI_USE_JACK=OFF"
    "-DGO_USE_JACK=OFF"
    "-DINSTALL_DEPEND=OFF"
  ] ++ lib.optional (!includeDemo) "-DINSTALL_DEMO=OFF";

  NIX_CFLAGS_COMPILE = lib.optional stdenv.isDarwin "-DTARGET_OS_IPHONE=0";

  postInstall = lib.optionalString stdenv.isDarwin ''
    mkdir -p $out/{Applications,bin,lib}
    mv $out/GrandOrgue.app $out/Applications/
    for lib in $out/Applications/GrandOrgue.app/Contents/MacOS/lib*; do
      ln -s $lib $out/lib/
    done
    makeWrapper $out/{Applications/GrandOrgue.app/Contents/MacOS,bin}/GrandOrgue
  '';

  meta = {
    description = "Virtual Pipe Organ Software";
    homepage = "https://sourceforge.net/projects/ourorgan";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.puzzlewolf ];
  };
}
