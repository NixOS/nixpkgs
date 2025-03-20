{
  stdenv,
  lib,
  fetchFromGitHub,
  runCommandLocal,
  mbrola-voices,
}:

let
  pname = "mbrola";
  version = "3.3-unstable-2024-01-29";

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
      rev = "bf17e9e1416a647979ac683657a536e8ca5d880e";
      hash = "sha256-ZjCl1gx/6sGtpXAYO4sAh6dutjwzClQ7kZoq0WaaBlU=";
    };

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
