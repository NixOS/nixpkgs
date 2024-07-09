{ lib
, stdenvNoCC
, fetchurl
, unzip
, gtk-engine-murrine
, colorVariants ? [] # default: install all icons
}:

let
  pname = "sweet";
  colorVariantList = [
    "Sweet-Ambar-Blue-Dark-v40"
    "Sweet-Ambar-Blue-Dark"
    "Sweet-Ambar-Blue-v40"
    "Sweet-Ambar-Blue"
    "Sweet-Ambar-v40"
    "Sweet-Ambar"
    "Sweet-Dark-v40"
    "Sweet-Dark"
    "Sweet-mars-v40"
    "Sweet-mars"
    "Sweet-v40"
    "Sweet"
  ];

in
lib.checkListOfEnum "${pname}: color variants" colorVariantList colorVariants

stdenvNoCC.mkDerivation (finalAttrs: {
  inherit pname;
  version = "5.0";

  srcs = [
    (fetchurl {
      url = "https://github.com/EliverLara/Sweet/releases/download/v${finalAttrs.version}/Sweet-Ambar-Blue-Dark-v40.tar.xz";
      hash = "sha256-fCCkkEYr4XPnP5aPrs3HAwIwM/Qb0NFY8Rf1ABu0ygY=";
    })
    (fetchurl {
      url = "https://github.com/EliverLara/Sweet/releases/download/v${finalAttrs.version}/Sweet-Ambar-Blue-Dark.tar.xz";
      hash = "sha256-xMAqUsol1FPeFoq8KLTmKCeZMF34FDAjhiagsRmjGT8=";
    })
    (fetchurl {
      url = "https://github.com/EliverLara/Sweet/releases/download/v${finalAttrs.version}/Sweet-Ambar-Blue-v40.tar.xz";
      hash = "sha256-JlpomJ8Ao4bJFJbCDliRtxNckEG3LzINBqhWzfTARJs=";
    })
    (fetchurl {
      url = "https://github.com/EliverLara/Sweet/releases/download/v${finalAttrs.version}/Sweet-Ambar-Blue.tar.xz";
      hash = "sha256-HKJ/Ca5cy91kJZVEETyMcOcrgLliHF/S2rdBmWfKi08=";
    })
    (fetchurl {
      url = "https://github.com/EliverLara/Sweet/releases/download/v${finalAttrs.version}/Sweet-Ambar-v40.tar.xz";
      hash = "sha256-0LjARDbSPyQWN5nT97k2c//eebxhgStGYsebpNQn9+w=";
    })
    (fetchurl {
      url = "https://github.com/EliverLara/Sweet/releases/download/v${finalAttrs.version}/Sweet-Ambar.tar.xz";
      hash = "sha256-UjH4popJCqQ18HZUngsO6cE4axSAM7/EXwM8nHAdVS4=";
    })
    (fetchurl {
      url = "https://github.com/EliverLara/Sweet/releases/download/v${finalAttrs.version}/Sweet-Dark-v40.tar.xz";
      hash = "sha256-4/e81slrkcO3WdrQ2atGHdZsErlzme4mRImfLvmGJnQ=";
    })
    (fetchurl {
      url = "https://github.com/EliverLara/Sweet/releases/download/v${finalAttrs.version}/Sweet-Dark.tar.xz";
      hash = "sha256-Tv+xtUee1TIdRLlnP84aVfk+V6xgeeeICRZCdeSSjE8=";
    })
    (fetchurl {
      url = "https://github.com/EliverLara/Sweet/releases/download/v${finalAttrs.version}/Sweet-mars-v40.tar.xz";
      hash = "sha256-FmJoPeQ8iLA6X6lFawBqG8lviQXWBHG5lgQsZvU68BM=";
    })
    (fetchurl {
      url = "https://github.com/EliverLara/Sweet/releases/download/v${finalAttrs.version}/Sweet-mars.tar.xz";
      hash = "sha256-bqL9jR8yPF9ZnEZ1O+P3/e6E59m+MY7mQNT3BhYVhu4=";
    })
    (fetchurl {
      url = "https://github.com/EliverLara/Sweet/releases/download/v${finalAttrs.version}/Sweet-v40.tar.xz";
      hash = "sha256-Oesx/McKmTlqwJX8u6RrV3AtOIB73BQveD8slbD14js=";
    })
    (fetchurl {
      url = "https://github.com/EliverLara/Sweet/releases/download/v${finalAttrs.version}/Sweet.tar.xz";
      hash = "sha256-m0tQHV/3UkDoOAmBZF6Nvugj6fEkmLbeLPdQ/IFkHOo=";
    })
  ];

  nativeBuildInputs = [ unzip ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/themes/
    cp -r ${lib.concatStringsSep " " (if colorVariants != [] then colorVariants else colorVariantList)} $out/share/themes/
    runHook postInstall
  '';

  meta = with lib; {
    description = "Light and dark colorful Gtk3.20+ theme";
    homepage = "https://github.com/EliverLara/Sweet";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ fuzen d3vil0p3r ];
    platforms = platforms.unix;
  };
})
