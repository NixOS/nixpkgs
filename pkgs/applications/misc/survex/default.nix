{ lib
, stdenv
, fetchurl
, fetchpatch
, Carbon
, Cocoa
, ffmpeg
, glib
, libGLU
, libICE
, libX11
, mesa
, perl
, pkg-config
, proj
, python3
, wrapGAppsHook
, wxGTK32
}:

stdenv.mkDerivation rec {
  pname = "survex";
  version = "1.4.3";

  src = fetchurl {
    url = "https://survex.com/software/${version}/${pname}-${version}.tar.gz";
    hash = "sha256-7NtGTe9xNRPEvG9fQ2fC6htQLEMHfqGmBM2ezhi6oNM=";
  };

  patches = [
    # Fix cavern.tst to work with SOURCE_DATE_EPOCH set
    (fetchpatch {
      url = "https://github.com/ojwb/survex/commit/b1200a60be7bdea20ffebbd8bb15386041727fa6.patch";
      hash = "sha256-OtFjqpU+u8XGy+PAHg2iea++b681p/Kl8YslisBs4sA=";
    })
  ];

  nativeBuildInputs = [
    perl
    pkg-config
    python3
    wrapGAppsHook
  ];

  buildInputs = [
    ffmpeg
    glib
    libGLU
    mesa
    proj
    wxGTK32
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    Carbon
    Cocoa
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [
    libICE
    libX11
  ];

  postPatch = ''
    patchShebangs .
  '';

  enableParallelBuilding = true;
  doCheck = (!stdenv.isDarwin); # times out
  enableParallelChecking = false;

  meta = with lib; {
    description = "Free Software/Open Source software package for mapping caves";
    longDescription = ''
      Survex is a Free Software/Open Source software package for mapping caves,
      licensed under the GPL. It is designed to be portable and can be run on a
      variety of platforms, including Linux/Unix, macOS, and Microsoft Windows.
    '';
    homepage = "https://survex.com/";
    changelog = "https://github.com/ojwb/survex/raw/v${version}/NEWS";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.matthewcroughan ];
    platforms = platforms.all;
  };
}
