{ stdenv, lib, fetchFromGitHub, substituteAll, cmake, pkgconfig
, alsaLib, ffmpeg_2, glib, openssl, pcre, zlib
, libX11, libXcursor, libXdamage, libXext, libXi, libXinerama, libXrandr, libXrender, libXv
, libxkbcommon, libxkbfile
, wayland
, gstreamer, gst-plugins-base, gst-plugins-good
, libpulseaudio ? null
, cups ? null
, pcsclite ? null
, systemd ? null
, buildServer ? true
, optimize ? true
}:

stdenv.mkDerivation rec {
  name = "freerdp-git-${version}";
  version = "20170201";

  src = fetchFromGitHub {
    owner  = "FreeRDP";
    repo   = "FreeRDP";
    rev    = "6001cb710dc67eb8811362b7bf383754257a902b";
    sha256 = "0l2lwqk2r8rq8a0f91wbb30kqg21fv0k0508djpwj0pa9n73fgmg";
  };

  # outputs = [ "bin" "out" "dev" ];

  prePatch = ''
    export HOME=$TMP
    substituteInPlace "libfreerdp/freerdp.pc.in" \
      --replace "Requires:" "Requires: @WINPR_PKG_CONFIG_FILENAME@"
  '';

  patches = with lib; [
  ] ++ optional (pcsclite != null)
      (substituteAll {
        src = ./dlopen-absolute-paths.diff;
        inherit pcsclite;
      });

  buildInputs = with lib; [
    alsaLib cups ffmpeg_2 glib openssl pcre pcsclite libpulseaudio zlib
    gstreamer gst-plugins-base gst-plugins-good
    libX11 libXcursor libXdamage libXext libXi libXinerama libXrandr libXrender libXv
    libxkbcommon libxkbfile
    wayland
  ] ++ optional stdenv.isLinux systemd;

  nativeBuildInputs = [
    cmake pkgconfig
  ];

  doCheck = false;

  cmakeFlags = with lib; [
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DWITH_CUNIT=OFF"
    "-DWITH_OSS=OFF"
  ] ++ optional (libpulseaudio != null) "-DWITH_PULSE=ON"
    ++ optional (cups != null)          "-DWITH_CUPS=ON"
    ++ optional (pcsclite != null)      "-DWITH_PCSC=ON"
    ++ optional buildServer             "-DWITH_SERVER=ON"
    ++ optional optimize                "-DWITH_SSE2=ON";

  meta = with lib; {
    description = "A Remote Desktop Protocol Client";
    longDescription = ''
      FreeRDP is a client-side implementation of the Remote Desktop Protocol (RDP)
      following the Microsoft Open Specifications.
    '';
    homepage = http://www.freerdp.com/;
    license = licenses.asl20;
    maintainers = with maintainers; [ wkennington peterhoeg ];
    platforms = platforms.unix;
  };
}
