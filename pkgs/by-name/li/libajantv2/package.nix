{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
}:

# Warning: We are aware that the upstream changed and there are new releases,
# this got initally packaged for obs-studio which appears to fail to build even upstream with the new version.
# https://github.com/NixOS/nixpkgs/pull/296191 / https://github.com/obsproject/obs-studio/pull/10037
stdenv.mkDerivation rec {
  pname = "libajantv2";
  version = "16.2-bugfix5";

  src = fetchFromGitHub {
    owner = "aja-video";
    repo = "ntv2";
    rev = "v${version}";
    sha256 = "sha256-h5PKWMwqTeI5/EaTWkjYojuvDU0FyMpzIjWB98UOJwc=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];

  postInstall = ''
    mkdir -p "$out/lib/pkgconfig"
    cat >"$out/lib/pkgconfig/libajantv2.pc" <<EOF
    prefix=$out
    libdir=\''${prefix}/lib
    includedir=\''${prefix}/include/ajalibraries

    Name: libajantv2
    Description: Library for controlling AJA NTV2 video devices
    Version: ${version}
    Libs: -L\''${libdir} -lajantv2
    Cflags: -I\''${includedir} -I\''${includedir}/ajantv2/includes
    EOF
  '';

  meta = with lib; {
    description = "AJA NTV2 Open Source Static Libs and Headers for building applications that only wish to statically link against";
    homepage = "https://github.com/aja-video/ntv2";
    license = with licenses; [ mit ];
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
