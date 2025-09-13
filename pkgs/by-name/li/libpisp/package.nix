{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  meson,
  ninja,
  boost,
  nlohmann_json,
  glibc,
  libgcc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libpisp";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "raspberrypi";
    repo = "libpisp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YshU7G5Rov67CVwFbf5ENp2j5ptAvkVrlMu85KmnEpk=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
  ];
  buildInputs = [
    boost
    nlohmann_json
  ];

  preFixup = ''
    so=$out/lib/libpisp.so.1
    patchelf --set-soname $so $so
    patchelf --remove-rpath $so
    needed=$(patchelf --print-needed $so)
    for pkg in ${glibc} ${boost} ${libgcc} ${stdenv.cc.cc.lib}; do
      for lib in $needed; do
        for libpath in $(find -L $pkg/lib -type f -name "$lib"); do
          patchelf --replace-needed $lib $libpath $so
        done
      done
    done
  '';

  meta = with lib; {
    homepage = "https://github.com/raspberrypi/libpisp";
    description = "Helper library to generate run-time configuration for the Raspberry Pi ISP (PiSP), consisting of the Frontend and Backend hardware components";
    license = licenses.bsd2;
    platforms = platforms.all;
  };
})
