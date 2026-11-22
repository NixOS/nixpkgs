{
  stdenv,
  lib,
  fetchurl,
  copyDesktopItems,
  makeDesktopItem,
  makeWrapper,
  unzip,
  scummvm,
}:

let
  generic =
    {
      plong,
      pshort,
      pcode,
      description,
      version,
      files,
      docs ? [ "readme.txt" ],
      ...
    }@attrs:
    let
      attrs' = removeAttrs attrs [
        "plong"
        "pshort"
        "pcode"
        "description"
        "docs"
        "files"
        "version"
      ];
      pname = lib.replaceStrings [ " " ":" ] [ "-" "" ] (lib.toLower plong);
    in
    stdenv.mkDerivation (
      {
        inherit pname version;

        __structuredAttrs = true;
        strictDeps = true;

        nativeBuildInputs = [
          copyDesktopItems
          makeWrapper
          unzip
        ];

        dontBuild = true;
        dontFixup = true;

        installPhase = ''
           runHook preInstall

           mkdir -p $out/share/{${pname},doc/${pname}}

          ${lib.concatMapStringsSep "\n" (f: "mv ${f} $out/share/doc/${pname}") docs}
          ${lib.concatMapStringsSep "\n" (f: "mv ${f} $out/share/${pname}") files}

           makeWrapper ${lib.getExe scummvm} $out/bin/${pshort} \
             --add-flags "--path=$out/share/${pname} --fullscreen ${pcode}"

           runHook postInstall
        '';

        desktopItems = [
          (makeDesktopItem {
            name = pname;
            desktopName = plong;
            comment = description;
            genericName = description;
            exec = pshort;
            icon = "${scummvm}/share/icons/hicolor/scalable/apps/org.scummvm.scummvm.svg";
            categories = [
              "Game"
              "AdventureGame"
            ];
          })
        ];

        meta = {
          homepage = "https://www.scummvm.org";
          license = lib.licenses.free; # refer to the readme for exact wording
          maintainers = with lib.maintainers; [
            keenanweaver
            peterhoeg
          ];
          inherit description;
          inherit (scummvm.meta) platforms;
          mainProgram = pshort;
        };
      }
      // attrs'
    );

in
{
  beneath-a-steel-sky = generic rec {
    plong = "Beneath a Steel Sky";
    pshort = "bass";
    pcode = "sky";
    description = "2D point-and-click science fiction thriller set in a bleak vision of the future";
    version = "1.2";
    src = fetchurl {
      url = "https://downloads.scummvm.org/frs/extras/Beneath%20a%20Steel%20Sky/${pshort}-cd-${version}.zip";
      hash = "sha256-UyCblADqtv1/pxUYsvNXyN51z+qlulcCRXWrecyXRZM=";
    };
    files = [ "sky.*" ];
  };

  broken-sword-25 = generic rec {
    plong = "Broken Sword 2.5";
    pshort = "sword25";
    pcode = "sword25";
    description = "Fan game of the Broken Sword series";
    version = "1.0";
    src = fetchurl {
      url = "https://downloads.scummvm.org/frs/extras/Broken%20Sword%202.5/${pshort}-v${version}.zip";
      hash = "sha256-/2P5EPu1qnumG8qPyt05jWiElqoCJFX0KjBeR90Ockc=";
    };
    sourceRoot = ".";
    docs = [
      "README"
      "license-original.txt"
    ];
    files = [ "data.b25c" ];
  };

  drascula-the-vampire-strikes-back = generic rec {
    plong = "Drascula: The Vampire Strikes Back";
    pshort = "drascula";
    pcode = "drascula";
    description = "Spanish 2D classic point & click style adventure with tons of humor and an easy interface";
    version = "1.0";
    src = fetchurl {
      url = "https://downloads.scummvm.org/frs/extras/Drascula_%20The%20Vampire%20Strikes%20Back/${pshort}-${version}.zip";
      hash = "sha256-tzH2y1oiuotMOzNi9XC5oQpntssLOVOUsZqUs25OQt4=";
    };
    sourceRoot = ".";
    docs = [
      "readme.txt"
      "drascula.doc"
    ];
    files = [ "Packet.001" ];
  };

  dreamweb = generic rec {
    plong = "Dreamweb";
    pshort = "dreamweb";
    pcode = "dreamweb";
    description = "2D point-and-click cyberpunk top-down adventure game";
    version = "1.1";
    src = fetchurl {
      url = "https://downloads.scummvm.org/frs/extras/Dreamweb/${pshort}-cd-uk-${version}.zip";
      hash = "sha256-Sm8TkRzmfWLFJuQQSOwGeyefGzeMkhDzngzo0/K4AUI=";
    };
    sourceRoot = ".";
    docs = [ "license.txt" ];
    files = [
      "DREAMWEB.*"
      "SPEECH"
      "track01.flac"
    ];
  };

  flight-of-the-amazon-queen = generic rec {
    plong = "Flight of the Amazon Queen";
    pshort = "fotaq";
    pcode = "queen";
    description = "2D point-and-click adventure game set in the 1940s";
    version = "1.1";
    src = fetchurl {
      url = "https://downloads.scummvm.org/frs/extras/Flight%20of%20the%20Amazon%20Queen/FOTAQ_Talkie-${version}.zip";
      hash = "sha256-olzdXgA6Cl5AKvmbIYzH6oGtAyyza4wF3zvRFnA42Kg=";
    };
    sourceRoot = ".";
    files = [ "*.1c" ];
  };

  lure-of-the-temptress = generic rec {
    plong = "Lure of the Temptress";
    pshort = "lott";
    pcode = "lure";
    description = "2D point-and-click adventure game with a fantasy theme";
    version = "1.1";
    src = fetchurl {
      url = "https://downloads.scummvm.org/frs/extras/Lure%20of%20the%20Temptress/lure-${version}.zip";
      hash = "sha256-8xeCRaFIPaEWjDoR5wtl0zw4nx9d9j1POjVohsGJAQg=";
    };
    docs = [
      "README"
      "*.txt"
      "*.pdf"
      "*.PDF"
    ];
    files = [ "*.vga" ];
  };

  mystery-house = generic {
    plong = "Mystery House";
    pshort = "mysteryhouse";
    pcode = "hires1";
    description = "Text adventure with Apple II graphics, the first Sierra On-Line game";
    version = "1.0";
    src = fetchurl {
      url = "https://downloads.scummvm.org/frs/extras/Mystery%20House/MYSTHOUS.zip";
      hash = "sha256-raQSIooUk5RImyjGx/nrqwcitS4Ecy/QqiKUlnPPo6A=";
    };
    sourceRoot = ".";
    docs = [ ];
    files = [ "MYSTHOUS.DSK" ];
  };

  nippon-safes-inc = generic rec {
    plong = "Nippon Safes Inc";
    pshort = "nippon";
    pcode = "nippon";
    description = "Comedy point-and-click adventure game set in a futuristic Japan";
    version = "1.0";
    src = fetchurl {
      url = "https://downloads.scummvm.org/frs/extras/Nippon%20Safes/nippon-${version}.zip";
      hash = "sha256-U+fixgBl5K7RkxabvNz9ERP6aNPv4cgkC6BzwOINYT8=";
    };
    sourceRoot = ".";
    docs = [
      "README"
      "readme.txt"
    ];
    files = [
      "*.CNV"
      "*.MID"
      "*.TAB"
      "DISK*"
      "EN"
      "FR"
      "GE"
      "IT"
    ];
  };

  sfinx = generic rec {
    plong = "Sfinx";
    pshort = "sfinx";
    pcode = "sfinx";
    description = "Polish 2D point-and-click adventure game set in a fantasy kingdom";
    version = "1.1";
    src = fetchurl {
      url = "https://downloads.scummvm.org/frs/extras/Sfinx/sfinx-en-v${version}.zip";
      hash = "sha256-9RazCgRlJveMvJI9j5B9Jnq5ZMzZt3CvxyNQ6NRn7E0=";
    };
    docs = [ "license.txt" ];
    files = [ "vol.*" ];
  };

  soltys = generic rec {
    plong = "Soltys";
    pshort = "soltys";
    pcode = "soltys";
    description = "Polish 2D point-and-click adventure game about a village mayor";
    version = "1.0";
    src = fetchurl {
      url = "https://downloads.scummvm.org/frs/extras/Soltys/soltys-en-v${version}.zip";
      hash = "sha256-h7ieZUuKW46+NCy0xcYEmrmkOl77R02cSbr7d9zOSPY=";
    };
    sourceRoot = ".";
    docs = [ "license.txt" ];
    files = [ "vol.*" ];
  };
}
