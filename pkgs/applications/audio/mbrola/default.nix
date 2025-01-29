{
  stdenv,
  lib,
  fetchFromGitHub,
  runCommandLocal,
  mbrola-voices,
}:

let
  pname = "mbrola";
  version = "3.3";

  meta = with lib; {
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ davidak ];
    platforms = platforms.all;
    description = "Speech synthesizer based on the concatenation of diphones";
    homepage = "https://github.com/numediart/MBROLA";
  };

  bin = stdenv.mkDerivation {
    pname = "${pname}-bin";
    inherit version;

    src = fetchFromGitHub {
      owner = "numediart";
      repo = "MBROLA";
      rev = version;
      sha256 = "1w86gv6zs2cbr0731n49z8v6xxw0g8b0hzyv2iqb9mqcfh38l8zy";
    };

    postPatch = ''
      substituteInPlace Makefile \
        --replace-fail 'O6' 'O3'
      substituteInPlace Misc/common.h \
        --replace-fail '|| defined(TARGET_OS_MAC)' ""
      substituteInPlace Misc/common.c \
        --replace-fail '|| defined(TARGET_OS_MAC)' ""
    '';

    # required for cross compilation
    makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

    env = lib.optionalAttrs stdenv.cc.isGNU {
      NIX_CFLAGS_COMPILE = "-Wno-error=implicit-function-declaration";
    };

    installPhase = ''
      runHook preInstall
      install -D Bin/mbrola $out/bin/mbrola
      rm -rf $out/share/mbrola/voices/*
      runHook postInstall
    '';

    meta = meta // {
      description = "Speech synthesizer based on the concatenation of diphones (binary only)";
    };
  };

in
runCommandLocal "${pname}-${version}"
  {
    inherit pname version meta;
  }
  ''
    mkdir -p "$out/share/mbrola"
    ln -s '${mbrola-voices}/data' "$out/share/mbrola/voices"
    ln -s '${bin}/bin' "$out/"
  ''
