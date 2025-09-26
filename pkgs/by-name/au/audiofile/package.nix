{
  stdenv,
  lib,
  fetchurl,
  fetchpatch,
  alsa-lib,
}:

let

  fetchDebianPatch =
    {
      name,
      debname,
      sha256,
    }:
    fetchpatch {
      inherit sha256 name;
      url = "https://salsa.debian.org/multimedia-team/audiofile/raw/debian/0.3.6-7/debian/patches/${debname}";
    };

in

stdenv.mkDerivation rec {
  pname = "audiofile";
  version = "0.3.6";

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
  ];

  src = fetchurl {
    url = "https://audiofile.68k.org/audiofile-${version}.tar.gz";
    sha256 = "0rb927zknk9kmhprd8rdr4azql4gn2dp75a36iazx2xhkbqhvind";
  };

  outputs = [
    "out"
    "dev"
    "man"
  ];

  # std::unary_function has been removed in c++17
  makeFlags = [ "CXXFLAGS=-std=c++11" ];

  # Even when statically linking, libstdc++.la is put in dependency_libs here,
  # and hence libstdc++.so passed to the linker, just pass -lstdc++ and let the
  # compiler do what it does best.  (libaudiofile.la is a generated file, so we
  # have to run `make` that far first).
  #
  # Without this, the executables in this package (sfcommands and examples)
  # fail to build: https://github.com/NixOS/nixpkgs/issues/103215
  #
  # There might be a more sensible way to do this with autotools, but I am not
  # smart enough to discover it.
  preBuild = lib.optionalString stdenv.hostPlatform.isStatic ''
    make -C libaudiofile $makeFlags
    sed -i "s/dependency_libs=.*/dependency_libs=' -lstdc++'/" libaudiofile/libaudiofile.la
  '';

  patches = [
    ./gcc-6.patch
    ./CVE-2015-7747.patch

    (fetchDebianPatch {
      name = "CVE-2017-6829.patch";
      debname = "04_clamp-index-values-to-fix-index-overflow-in-IMA.cpp.patch";
      sha256 = "04qxl51i64c53v69q2kx61qdq474f4vapk8rq97cipj7yrar392m";
    })
    (fetchDebianPatch {
      name = "CVE-2017-6827+CVE-2017-6828+CVE-2017-6832+CVE-2017-6835+CVE-2017-6837.patch";
      debname = "05_Always-check-the-number-of-coefficients.patch";
      sha256 = "1ih03kfkabffi6ymp6832q470i28rsds78941vzqlshnqjb2nnxw";
    })
    (fetchDebianPatch {
      name = "CVE-2017-6839.patch";
      debname = "06_Check-for-multiplication-overflow-in-MSADPCM-decodeSam.patch";
      sha256 = "0a8s2z8rljlj03p7l1is9s4fml8vyzvyvfrh1m6xj5a8vbi635d0";
    })
    (fetchDebianPatch {
      name = "CVE-2017-6830+CVE-2017-6834+CVE-2017-6836+CVE-2017-6838.patch";
      debname = "07_Check-for-multiplication-overflow-in-sfconvert.patch";
      sha256 = "0rfba8rkasl5ycvc0kqlzinkl3rvyrrjvjhpc45h423wmjk2za2l";
    })
    (fetchDebianPatch {
      name = "audiofile-fix-multiplyCheckOverflow-signature.patch";
      debname = "08_Fix-signature-of-multiplyCheckOverflow.-It-returns-a-b.patch";
      sha256 = "032p5jqp7q7jgc5axdnazz00zm7hd26z6m5j55ifs0sykr5lwldb";
    })
    (fetchDebianPatch {
      name = "CVE-2017-6831.patch";
      debname = "09_Actually-fail-when-error-occurs-in-parseFormat.patch";
      sha256 = "0csikmj8cbiy6cigg0rmh67jrr0sgm56dfrnrxnac3m9635nxlac";
    })
    (fetchDebianPatch {
      name = "CVE-2017-6833.patch";
      debname = "10_Check-for-division-by-zero-in-BlockCodec-runPull.patch";
      sha256 = "1rlislkjawq98bbcf1dgl741zd508wwsg85r37ca7pfdf6wgl6z7";
    })
    (fetchDebianPatch {
      name = "CVE-2018-13440.patch";
      debname = "11_CVE-2018-13440.patch";
      sha256 = "sha256-qDfjiBJ4QXgn8588Ra1X0ViH0jBjtFS/+2zEGIUIhuo=";
    })
    (fetchDebianPatch {
      name = "CVE-2018-17095.patch";
      debname = "12_CVE-2018-17095.patch";
      sha256 = "sha256-FC89EFZuRLcj5x4wZVqUlitEMTRPSZk+qzQpIoVk9xY=";
    })
    (fetchDebianPatch {
      name = "CVE-2022-24599.patch";
      debname = "0013-Fix-CVE-2022-24599.patch";
      sha256 = "sha256-DHJQ4B6cvKfSlXy66ZC5RNaCMDaygj8dWLZZhJnhw1E=";
    })
    (fetchDebianPatch {
      name = "1_CVE-2019-13147.patch";
      debname = "0014-Partial-fix-of-CVE-2019-13147.patch";
      sha256 = "sha256-clb/XiIZbmttPr2dT9AZsbQ97W6lwifEwMO4l2ZEh0k=";
    })
    (fetchDebianPatch {
      name = "2_CVE-2019-13147.patch";
      debname = "0015-Partial-fix-of-CVE-2019-13147.patch";
      sha256 = "sha256-JOZIw962ae7ynnjJXGO29i8tuU5Dhk67DmB0o5/vSf4=";
    })
  ];

  meta = with lib; {
    description = "Library for reading and writing audio files in various formats";
    homepage = "http://www.68k.org/~michael/audiofile/";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ lovek323 ];
    platforms = platforms.unix;
  };
}
