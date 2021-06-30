{ lib
, config
, stdenv
, fetchurl
, fetchpatch
, boost
, ffmpeg
, ffms
, fftw
, fontconfig
, freetype
, icu
, intltool
, libGL
, libGLU
, libX11
, libass
, libiconv
, pkg-config
, wxGTK
, zlib

, spellcheckSupport ? true
, hunspell ? null

, automationSupport ? true
, lua ? null

, openalSupport ? false
, openal ? null

, alsaSupport ? stdenv.isLinux
, alsa-lib ? null

, pulseaudioSupport ? config.pulseaudio or stdenv.isLinux
, libpulseaudio ? null

, portaudioSupport ? false
, portaudio ? null
}:

assert spellcheckSupport -> (hunspell != null);
assert automationSupport -> (lua != null);
assert openalSupport -> (openal != null);
assert alsaSupport -> (alsa-lib != null);
assert pulseaudioSupport -> (libpulseaudio != null);
assert portaudioSupport -> (portaudio != null);

let
  inherit (lib) optional;
in
stdenv.mkDerivation rec {
  pname = "aegisub";
  version = "3.2.2";

  src = fetchurl {
    url = "http://ftp.aegisub.org/pub/releases/${pname}-${version}.tar.xz";
    hash = "sha256-xV4zlFuC2FE8AupueC8Ncscmrc03B+lbjAAi9hUeaIU=";
  };

  patches = [
    # Compatibility with ICU 59
    (fetchpatch {
      url = "https://github.com/Aegisub/Aegisub/commit/dd67db47cb2203e7a14058e52549721f6ff16a49.patch";
      sha256 = "sha256-R2rN7EiyA5cuBYIAMpa0eKZJ3QZahfnRp8R4HyejGB8=";
    })

    # Compatbility with Boost 1.69
    (fetchpatch {
      url = "https://github.com/Aegisub/Aegisub/commit/c3c446a8d6abc5127c9432387f50c5ad50012561.patch";
      sha256 = "sha256-7nlfojrb84A0DT82PqzxDaJfjIlg5BvWIBIgoqasHNk=";
    })

    # Compatbility with make 4.3
    (fetchpatch {
      url = "https://github.com/Aegisub/Aegisub/commit/6bd3f4c26b8fc1f76a8b797fcee11e7611d59a39.patch";
      sha256 = "sha256-rG8RJokd4V4aSYOQw2utWnrWPVrkqSV3TAvnGXNhLOk=";
    })

    # Compatibility with ffms2
    (fetchpatch {
      url = "https://github.com/Aegisub/Aegisub/commit/1aa9215e7fc360de05da9b7ec2cd68f1940af8b2.patch";
      sha256 = "sha256-JsuI4hQTcT0TEqHHoSsGbuiTg4hMCH3Cxp061oLk8Go=";
    })

    ./update-ffms2.patch

    # Compatibility with X11
    (fetchpatch {
      url = "https://github.com/Aegisub/Aegisub/commit/7a6da26be6a830f4e1255091952cc0a1326a4520.patch";
      sha256 = "sha256-/aTcIjFlZY4N9+IyHL4nwR0hUR4HTJM7ibbdKmNxq0w=";
    })
  ];

  nativeBuildInputs = [
    intltool
    pkg-config
  ];
  buildInputs = [
    boost
    ffmpeg
    ffms
    fftw
    fontconfig
    freetype
    icu
    libGL
    libGLU
    libX11
    libass
    libiconv
    wxGTK
    zlib
  ]
  ++ optional alsaSupport alsa-lib
  ++ optional automationSupport lua
  ++ optional openalSupport openal
  ++ optional portaudioSupport portaudio
  ++ optional pulseaudioSupport libpulseaudio
  ++ optional spellcheckSupport hunspell
  ;

  enableParallelBuilding = true;

  hardeningDisable = [
    "bindnow"
    "relro"
  ];

  postPatch = ''
    sed -i 's/-Wno-c++11-narrowing/-Wno-narrowing/' configure.ac src/Makefile
  '';

  # compat with icu61+
  # https://github.com/unicode-org/icu/blob/release-64-2/icu4c/readme.html#L554
  CXXFLAGS = [ "-DU_USING_ICU_NAMESPACE=1" ];

  # this is fixed upstream though not yet in an officially released version,
  # should be fine remove on next release (if one ever happens)
  NIX_LDFLAGS = "-lpthread";

  postInstall = "ln -s $out/bin/aegisub-* $out/bin/aegisub";

  meta = with lib; {
    homepage = "https://github.com/Aegisub/Aegisub";
    description = "An advanced subtitle editor";
    longDescription = ''
      Aegisub is a free, cross-platform open source tool for creating and
      modifying subtitles. Aegisub makes it quick and easy to time subtitles to
      audio, and features many powerful tools for styling them, including a
      built-in real-time video preview.
    '';
    # The Aegisub sources are itself BSD/ISC, but they are linked against GPL'd
    # softwares - so the resulting program will be GPL
    license = licenses.bsd3;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
# TODO [ AndersonTorres ]: update to fork release
