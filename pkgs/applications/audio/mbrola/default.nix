{ stdenv, stdenvNoCC, lib, symlinkJoin, fetchFromGitHub }:

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

  voices = stdenvNoCC.mkDerivation {
    pname = "${pname}-voices";
    inherit version;

    src = fetchFromGitHub {
      owner = "numediart";
      repo = "MBROLA-voices";
      rev = "fe05a0ccef6a941207fd6aaad0b31294a1f93a51";  # using latest commit
      sha256 = "1w0y2xjp9rndwdjagp2wxh656mdm3d6w9cs411g27rjyfy1205a0";
    };

    dontBuild = true;
    installPhase = ''
      runHook preInstall
      install -d $out/share/mbrola/voices
      cp -R $src/data/* $out/share/mbrola/voices/
      runHook postInstall
    '';
    dontFixup = true;

    meta = meta // {
      description = "Speech synthesizer based on the concatenation of diphones (voice files)";
      homepage = "https://github.com/numediart/MBROLA-voices";
    };
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

    # required for cross compilation
    makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

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
symlinkJoin {
  inherit pname version meta;
  name = "${pname}-${version}";
  paths = [ bin voices ];
}
