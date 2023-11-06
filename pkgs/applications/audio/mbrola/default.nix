{ stdenv, lib, fetchFromGitHub, runCommandLocal }:

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

  # Very big (0.65 G) so kept as a fixed-output derivation to limit "duplicates".
  voices = fetchFromGitHub {
    owner = "numediart";
    repo = "MBROLA-voices";
    rev = "fe05a0ccef6a941207fd6aaad0b31294a1f93a51";  # using latest commit
    sha256 = "1w0y2xjp9rndwdjagp2wxh656mdm3d6w9cs411g27rjyfy1205a0";

    name = "${pname}-voices-${version}";
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
  runCommandLocal
    "${pname}-${version}"
    {
      inherit pname version meta;
    }
    ''
      mkdir -p "$out/share/mbrola"
      ln -s '${voices}/data' "$out/share/mbrola/voices"
      ln -s '${bin}/bin' "$out/"
    ''

