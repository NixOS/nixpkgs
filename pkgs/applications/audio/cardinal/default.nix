{
  stdenv
, fetchFromGitHub
, fetchzip
, freetype
, jansson
, lib
, libGL
, libX11
, libXcursor
, libXext
, libarchive
, libsamplerate
, pkg-config
, speexdsp
, libXrandr
, liblo
, mesa
, python3
}:

let
  # The package repo vendors some of the package dependencies as submodules.
  # Others are downloaded with `make deps`. Due to previous issues with the
  # `glfw` submodule and because we can not access the network when
  # building in a sandbox, we fetch the dependency source manually.
  pfft-source = fetchzip {
    url = "https://vcvrack.com/downloads/dep/pffft.zip";
    sha256 = "sha256-gYaumUeXYf3axAexGqWI/tYBs1dyebjAESo4o/DTjCA=";
  };
  nanovg-source = fetchFromGitHub {
    owner = "memononen";
    repo = "nanovg";
    rev = "0bebdb314aff9cfa28fde4744bcb037a2b3fd756";
    sha256 = "sha256-HmQhCE/zIKc3f+Zld229s5i5MWzRrBMF9gYrn8JVQzg=";
  };
  nanosvg-source = fetchFromGitHub {
    owner = "memononen";
    repo = "nanosvg";
    rev = "25241c5a8f8451d41ab1b02ab2d865b01600d949";
    sha256 = "sha256-b/aBmvuvKScF8zSkyF1tuqL9hov4XVLzKLTpr6p7mIQ=";
  };
  osdialog-source = fetchFromGitHub {
    owner = "AndrewBelt";
    repo = "osdialog";
    rev = "c92e8ad0e0b660cd693cf159ec9cb717bb4fd6cc";
    sha256 = "sha256-NmSgzFv8RY5CFeW33LaIudDCyanQb++5kUf1bcd/ZHg=";
  };
  oui-blendish-source = fetchFromGitHub {
    owner = "AndrewBelt";
    repo = "oui-blendish";
    rev = "2fc6405883f8451944ed080547d073c8f9f31898";
    sha256 = "sha256-/QZFZuI5kSsEvSfMJlcqB1HiZ9Vcf3vqLqWIMEgxQK8=";
  };
  QuickJS-source = fetchFromGitHub {
    owner = "JerrySievert";
    repo = "QuickJS";
    rev = "b70d5344013836544631c361ae20569b978176c9";
    sha256 = "sha256-hSWOGTmTJgtHVSBlEpv7w1qiyTgoAI1d7bQ66q59mik=";
  };
in

stdenv.mkDerivation rec {
  name = "cardinal-${version}";
  version = "unstable-2022-01-29";

  src = fetchFromGitHub {
    owner = "DISTRHO";
    repo = "cardinal";
    rev = "756271f1d280db4e1b56f041612609014d14b478";
    sha256 = "sha256-BZoeyrajVR5Gfj6QfLoV390y4MzgzxTpD+zsabW3bcg=";
    fetchSubmodules = true;
  };

  prePatch = ''
    # As we can't use `make dep` to set up the dependencies (as explained
    # above), we do it here manually
    mkdir -p src/Rack/dep/include

    cp -r ${pfft-source} src/Rack/dep/jpommier-pffft-source
    cp -r ${nanovg-source}/* src/Rack/dep/nanovg
    cp -r ${nanosvg-source}/* src/Rack/dep/nanosvg
    cp -r ${osdialog-source}/* src/Rack/dep/osdialog
    cp -r ${oui-blendish-source}/* src/Rack/dep/oui-blendish
    mkdir -p src/Rack/dep/QuickJS
    cp -r ${QuickJS-source }/* src/Rack/dep/QuickJS


    cp src/Rack/dep/jpommier-pffft-source/*.h src/Rack/dep/include
    cp src/Rack/dep/nanosvg/**/*.h src/Rack/dep/include
    cp src/Rack/dep/nanovg/src/*.h src/Rack/dep/include
    cp src/Rack/dep/osdialog/*.h src/Rack/dep/include
    cp src/Rack/dep/oui-blendish/*.h src/Rack/dep/include
    cp src/Rack/dep/QuickJS/*.h src/Rack/dep/include

    # substituteInPlace src/Rack/dep/oui-blendish/blendish.h --replace '#error "nanovg.h must be included first."' '#include "../include/nanovg.h"'
    # substituteInPlace src/Rack/dep/include/blendish.h --replace '#error "nanovg.h must be included first."' '#include "nanovg.h"'

    substituteInPlace src/Rack/dep/oui-blendish/blendish.h --replace '#ifndef NANOVG_H' '#include "../include/nanovg.h"
#ifndef NANOVG_H '
    substituteInPlace src/Rack/dep/include/blendish.h --replace '#ifndef NANOVG_H' '#include "nanovg.h"
#ifndef NANOVG_H '

    patchShebangs ./dpf/utils/generate-ttl.sh
  '';

  enableParallelBuilding = true;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    freetype
    jansson
    libGL
    libX11
    libXcursor
    libXext
    libarchive
    libsamplerate
    speexdsp
    libXrandr
    libXrandr
    liblo
    mesa
    python3
  ];

  makeFlags = [
    "SYSDEPS=true"
    "PREFIX=$(out)"
  ];

  meta = {
    description = "Plugin wrapper around VCV Rack";
    homepage = "https://github.com/DISTRHO/cardinal";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.magnetophon ];
    platforms = lib.platforms.all;
  };
}
