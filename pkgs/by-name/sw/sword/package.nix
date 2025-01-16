{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  icu,
  clucene_core,

  autoreconfHook,
  bzip2,
  curl,
  xz,
}:

stdenv.mkDerivation (
  finalAttrs:
  let
    # Used on Windows, where libpsl doesn't compile, yet
    curlDep = curl.override { pslSupport = false; };
  in
  {
    pname = "sword";
    version = "1.9.0";

    src = fetchurl {
      url = "https://www.crosswire.org/ftpmirror/pub/sword/source/v${lib.versions.majorMinor finalAttrs.version}/sword-${finalAttrs.version}.tar.gz";
      hash = "sha256-QkCc894vrxEIUj4sWsB0XSH57SpceO2HjuncwwNCa4o=";
    };

    nativeBuildInputs =
      [
        pkg-config
      ]
      ++ (lib.optionals stdenv.hostPlatform.isWindows [
        autoreconfHook # The Windows patch modifies autotools files
      ]);

    buildInputs =
      [
        icu
      ]
      ++ (lib.optionals stdenv.hostPlatform.isUnix [
        clucene_core
        curl
      ])
      ++ (lib.optionals stdenv.hostPlatform.isWindows [
        bzip2
        curlDep
        xz
      ]);

    outputs = [
      "out"
      "dev"
    ];

    prePatch = ''
      patchShebangs .;
    '';

    preConfigure = lib.optionalString stdenv.hostPlatform.isWindows ''
      substituteInPlace configure --replace-fail "-no-undefined" "-Wl,-no-undefined"
    '';

    patches = lib.optional stdenv.hostPlatform.isWindows ./sword-1.9.0-diatheke-includes.patch;

    configureFlags =
      [
        "--without-conf"
        "--enable-tests=no"
      ]
      ++ (lib.optionals stdenv.hostPlatform.isWindows [
        "--with-xz"
        "--with-bzip2"
        "--with-icuregex"
      ]);

    makeFlags = lib.optionals stdenv.hostPlatform.isWindows [
      "LDFLAGS=-no-undefined"
    ];

    env = {
      # When placed in nativeBuildInputs, icu.dev is finding the native ICU libs, but setting it
      # explicitly here has it finding the platform appropriate version
      ICU_CONFIG = lib.optionalString stdenv.hostPlatform.isWindows "${icu.dev}/bin/icu-config --noverify";
      CURL_CONFIG = lib.optionalString stdenv.hostPlatform.isWindows "${lib.getDev curlDep}/bin/curl-config";

      CXXFLAGS = (
        builtins.concatStringsSep " " (
          [
            "-Wno-unused-but-set-variable"
            "-Wno-unknown-warning-option"
            # compat with icu61+ https://github.com/unicode-org/icu/blob/release-64-2/icu4c/readme.html#L554
            "-DU_USING_ICU_NAMESPACE=1"
          ]
          ++ (lib.optionals stdenv.hostPlatform.isWindows [
            "-Wint-to-pointer-cast"
            "-fpermissive"
            "-D_ICUSWORD_"
            "-DCURL_STATICLIB"
          ])
        )
      );
    };

    meta = {
      description = "Software framework that allows research manipulation of Biblical texts";
      homepage = "https://www.crosswire.org/sword/";
      longDescription = ''
        The SWORD Project is the CrossWire Bible Society's free Bible software
        project. Its purpose is to create cross-platform open-source tools --
        covered by the GNU General Public License -- that allow programmers and
        Bible societies to write new Bible software more quickly and easily. We
        also create Bible study software for all readers, students, scholars, and
        translators of the Bible, and have a growing collection of many hundred
        texts in around 100 languages.
      '';
      license = lib.licenses.gpl2;
      maintainers = with lib.maintainers; [
        greg
      ];
      platforms = lib.platforms.all;
    };
  }
)
