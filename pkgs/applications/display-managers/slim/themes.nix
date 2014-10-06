{ stdenv, fetchurl, slim }:

# Inspired on aspell buildDict expression

let
  buildTheme =
    {fullName, src, version ? "testing"}:

    stdenv. mkDerivation rec {
      name = "${fullName}-${version}";

      inherit src;

      buildInputs = [ slim ];

      dontBuild = true;

      installPhase = ''
        install -dm755 $out/share/slim/themes/${name}
        install -m644 * $out/share/slim/themes/${name}
      '';

      meta = {
        description = "Slim theme for ${fullName}";
        platforms = stdenv.lib.platforms.linux;
      };
    };

in {

  archlinuxSimple = buildTheme {
    fullName = "archlinux-simple";
    src = fetchurl {
      url = "mirror://sourceforge/slim.berlios/slim-archlinux-simple.tar.gz";
      sha256 = "7d60d6782fa86302646fe67253467c04692d247f89bdbe87178f690f32b270db";
    };
  };

  capernoited = buildTheme {
    fullName = "capernoited";
    src = fetchurl {
      url = "mirror://sourceforge/slim.berlios/slim-capernoited.tar.gz";
      sha256 = "fb9163c6a2656d60f088dc4f2173aa7556a6794495122acfa7d3be7182f16b41";
    };
  };

  debianMoreblue = buildTheme {
    fullName = "debian-moreblue";
    src = fetchurl {
      url = "mirror://sourceforge/slim.berlios/slim-debian-moreblue.tar.bz2";
      sha256 = "5b76929827d4a4d604ddca4f42668cca3309b6f7bd659901021c6f49d6d2c481";
    };
  };

  fingerprint = buildTheme {
    fullName = "fingerprint";
    src = fetchurl {
      url = "mirror://sourceforge/slim.berlios/slim-fingerprint.tar.gz";
      sha256 = "48b703f84ce7b814cda0824f65cafebf695cd71a14166b481bb44616097d3144";
    };
  };

  flat = buildTheme {
    fullName = "flat";
    src = fetchurl {
      url = "mirror://sourceforge/slim.berlios/slim-flat.tar.gz";
      sha256 = "0092d531540f9da8ef07ad173e527c4ef9c088d04962d142be3c11f0c5c0c5e9";
    };
  };

  flower2 = buildTheme {
    fullName = "flower2";
    src = fetchurl {
      url = "mirror://sourceforge/slim.berlios/slim-flower2.tar.gz";
      sha256 = "840faf6459ffd6c2c363160c85cb98000717f9a425102976336f5d8f68ed95ee";
    };
  };

  gentooSimple = buildTheme {
    fullName = "gentoo-simple";
    src = fetchurl {
      url = "mirror://sourceforge/slim.berlios/slim-gentoo-simple.tar.bz2";
      sha256 = "27c8614cc930ca200acf81f1192febc102501744939d5cbe997141e37c96d8c2";
    };
  };

  lake = buildTheme {
    fullName = "lake";
    src = fetchurl {
      url = "mirror://sourceforge/slim.berlios/slim-lake.tar.gz";
      sha256 = "f7d662e37068a6c64cbf910adf3c192f1b50724baa427a8c9487cb9f7ed95851";
    };
  };

  lunar = buildTheme {
    fullName = "lunar-0.4";
    version = "";
    src = fetchurl {
      url = "mirror://sourceforge/slim.berlios/slim-lunar-0.4.tar.bz2";
      sha256 = "1543eb45e4d664377e0dd4f7f954aba005823034ba9692624398b3d58be87d76";
    };
  };

  mindlock = buildTheme {
    fullName = "mindlock";
    src = fetchurl {
      url = "mirror://sourceforge/slim.berlios/slim-mindlock.tar.gz";
      sha256 = "99a6e6acd55bf55ece18a3f644299517b71c1adc49efd87ce2d7e654fb67033c";
    };
  };

  parallelDimensions = buildTheme {
    fullName = "parallel-dimensions";
    src = fetchurl {
      url = "mirror://sourceforge/slim.berlios/slim-parallel-dimensions.tar.gz";
      sha256 = "2b17c3e6d3967a6a0744e20e6e05c9d3938f4ef04c62d49ddbd416bc4743046f";
    };
  };

  previous = buildTheme {
    fullName = "previous";
    src = fetchurl {
      url = "mirror://sourceforge/slim.berlios/slim-previous.tar.gz";
      sha256 = "1f2a69f8fc0dc8ed8eb86a4c1d1087ba7be486973fb81efab52a63c661d726f8";
    };
  };

  rainbow = buildTheme {
    fullName = "rainbow";
    src = fetchurl {
      url = "mirror://sourceforge/slim.berlios/slim-rainbow.tar.gz";
      sha256 = "d83e3afdb05be50cff7da037bb31208b2c152539d1a009740b13857f5f910072";
    };
  };

  rear-window = buildTheme {
    fullName = "rear-window";
    src = fetchurl {
      url = "mirror://sourceforge/slim.berlios/slim-rear-window.tar.gz";
      sha256 = "0b123706ccb67e94f626c183530ec5732b209bab155bc661d6a3f5cd5ee39511";
    };
  };

  scotlandRoad = buildTheme {
    fullName = "scotland-road";
    src = fetchurl {
      url = "mirror://sourceforge/slim.berlios/slim-scotland-road.tar.gz";
      sha256 = "fd60a434496ed39b968ffa1e5457b36cd12f64a4e2ecedffc675f97ca3f3bba1";
    };
  };

  subway = buildTheme {
    fullName = "subway";
    src = fetchurl {
      url = "mirror://sourceforge/slim.berlios/slim-subway.tar.gz";
      sha256 = "0205568e3e157973b113a83b26d8829ce9962a85ef7eb8a33d3ae2f3f9292253";
    };
  };

  wave = buildTheme {
    fullName = "wave";
    src = fetchurl {
      url = "mirror://sourceforge/slim.berlios/slim-wave.tar.gz";
      sha256 = "be75676da5bf8670daa48379bb9cc1be0b9a5faa09adbea967dfd7125320b959";
    };
  };

  zenwalk = buildTheme {
    fullName = "zenwalk";
    src = fetchurl {
      url = "mirror://sourceforge/slim.berlios/slim-zenwalk.tar.gz";
      sha256 = "f0f41d17ea505b0aa96a036e978fabaf673a51d3f81a919cb0d43364d4bc7a57";
    };
  };

  nixosSlim = buildTheme {
    fullName = "nixos-slim";
    src = fetchurl {
      url = "https://github.com/jagajaga/nixos-slim-theme/archive/1.1.tar.gz";
      sha256 = "0cawq38l8rcgd35vpdx3i1wbs3wrkcrng1c9qch0l4qncw505hv6";
    };
  };
}
