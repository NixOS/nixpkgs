{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  makeWrapper,
  alsa-lib,
  fontconfig,
  mesa_glu,
  libXcursor,
  libXinerama,
  libXrandr,
<<<<<<< HEAD
  xinput,
  libXi,
  libXext,
}:

stdenv.mkDerivation (finalAttrs: {
=======
  xorg,
}:

stdenv.mkDerivation rec {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pname = "bonzomatic";
  version = "2023-06-15";

  src = fetchFromGitHub {
    owner = "Gargaj";
    repo = "bonzomatic";
<<<<<<< HEAD
    tag = finalAttrs.version;
    hash = "sha256-hwK3C+p1hRwnuY2/vBrA0QsJGIcJatqq+U5/hzVCXEg=";
  };

  postPatch = ''
    substituteInPlace {,external/glfw/}CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 3.0)" "cmake_minimum_required(VERSION 3.10)"
  '';

=======
    tag = version;
    sha256 = "sha256-hwK3C+p1hRwnuY2/vBrA0QsJGIcJatqq+U5/hzVCXEg=";
  };

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  nativeBuildInputs = [
    cmake
    makeWrapper
  ];
<<<<<<< HEAD

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  buildInputs = [
    alsa-lib
    fontconfig
    mesa_glu
    libXcursor
    libXinerama
    libXrandr
<<<<<<< HEAD
    xinput
    libXi
    libXext
  ];

  postFixup = ''
    wrapProgram $out/bin/bonzomatic \
      --prefix LD_LIBRARY_PATH : "${lib.getLib alsa-lib}/lib"
  '';

  meta = {
    description = "Live shader coding tool and Shader Showdown workhorse";
    homepage = "https://github.com/gargaj/bonzomatic";
    license = lib.licenses.unlicense;
    maintainers = [ lib.maintainers.ilian ];
=======
    xorg.xinput
    xorg.libXi
    xorg.libXext
  ];

  postFixup = ''
    wrapProgram $out/bin/bonzomatic --prefix LD_LIBRARY_PATH : "${alsa-lib}/lib"
  '';

  meta = with lib; {
    description = "Live shader coding tool and Shader Showdown workhorse";
    homepage = "https://github.com/gargaj/bonzomatic";
    license = licenses.unlicense;
    maintainers = [ maintainers.ilian ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
    mainProgram = "bonzomatic";
  };
<<<<<<< HEAD
})
=======
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
