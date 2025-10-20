# hunspell dictionaries

{
  lib,
  stdenv,
  stdenvNoCC,
  fetchurl,
  fetchzip,
  fetchFromGitHub,
  unzip,
  coreutils,
  bash,
  which,
  zip,
  ispell,
  perl,
  python3,
  hunspell,
}:

let
  mkDict = lib.extendMkDerivation {
    constructDrv = stdenvNoCC.mkDerivation;

    extendDrvArgs =
      finalAttrs:
      {
        pname,
        readmeFile,
        dictFileName,
        ...
      }@args:
      {
        inherit pname;

        strictDeps = true;
        enableParallelBuilding = args.enableParallelBuilding or true;

        installPhase =
          args.installPhase or ''
            runHook preInstall
            # hunspell dicts
            install -dm755 "$out/share/hunspell"
            install -m644 ${dictFileName}.dic "$out/share/hunspell/"
            install -m644 ${dictFileName}.aff "$out/share/hunspell/"
            # myspell dicts symlinks
            install -dm755 "$out/share/myspell/dicts"
            ln -sv "$out/share/hunspell/${dictFileName}.dic" "$out/share/myspell/dicts/"
            ln -sv "$out/share/hunspell/${dictFileName}.aff" "$out/share/myspell/dicts/"
            # docs
            install -dm755 "$out/share/doc"
            install -m644 ${readmeFile} $out/share/doc/${finalAttrs.pname}.txt
            runHook postInstall
          '';
      };
  };

  mkDictFromRla =
    {
      shortName,
      shortDescription,
      dictFileName,
    }:
    mkDict rec {
      inherit dictFileName;
      version = "2.5";
      pname = "hunspell-dict-${shortName}-rla";
      readmeFile = "README.txt";
      src = fetchFromGitHub {
        owner = "sbosio";
        repo = "rla-es";
        rev = "v${version}";
        hash = "sha256-oGnxOGHzDogzUMZESydIxRTbq9Dmd03flwHx16AK1yk=";
      };
      meta = {
        description = "Hunspell dictionary for ${shortDescription} from rla";
        homepage = "https://github.com/sbosio/rla-es";
        license = with lib.licenses; [
          gpl3
          lgpl3
          mpl11
        ];
        maintainers = with lib.maintainers; [ renzo ];
        platforms = lib.platforms.all;
      };
      nativeBuildInputs = [
        bash
        coreutils
        which
        zip
        unzip
      ];
      postPatch = ''
        substituteInPlace ortograf/herramientas/make_dict.sh \
           --replace /bin/bash ${bash}/bin/bash \
           --replace /dev/stderr stderr.log

        substituteInPlace ortograf/herramientas/remover_comentarios.sh \
           --replace /bin/bash ${bash}/bin/bash \
      '';
      buildPhase = ''
        cd ortograf/herramientas
        bash -x ./make_dict.sh -l ${dictFileName} -2
        unzip ${dictFileName}.zip \
          ${dictFileName}.dic ${dictFileName}.aff ${readmeFile}
      '';
    };

  mkDictFromDSSO =
    {
      shortName,
      shortDescription,
      dictFileName,
    }:
    mkDict rec {
      inherit dictFileName;
      version = "2.40";
      # Should really use a string function or something
      _version = "2-40";
      pname = "hunspell-dict-${shortName}-dsso";
      _name = "ooo_swedish_dict_${_version}";
      readmeFile = "LICENSE_en_US.txt";
      src = fetchurl {
        url = "https://extensions.libreoffice.org/extensions/swedish-spelling-dictionary-den-stora-svenska-ordlistan/${version}/@@download/file/${_name}.oxt";
        hash = "sha256-uYKIHMdfXErxGZU1vUc17kdr3Ejt9j4/BftPcVZUp7w=";
      };
      meta = {
        longDescription = ''
          Svensk ordlista baserad på DSSO (den stora svenska ordlistan) och Göran
          Anderssons (goran@init.se) arbete med denna. Ordlistan hämtas från
          LibreOffice då dsso.se inte längre verkar vara med oss.
        '';
        description = "Hunspell dictionary for ${shortDescription} from LibreOffice";
        license = lib.licenses.lgpl3;
        platforms = lib.platforms.all;
      };
      nativeBuildInputs = [ unzip ];
      sourceRoot = ".";
      unpackCmd = ''
        unzip $src dictionaries/${dictFileName}.dic dictionaries/${dictFileName}.aff $readmeFile
      '';
      installPhase = ''
        # hunspell dicts
        install -dm755 "$out/share/hunspell"
        install -m644 dictionaries/${dictFileName}.dic "$out/share/hunspell/"
        install -m644 dictionaries/${dictFileName}.aff "$out/share/hunspell/"
        # myspell dicts symlinks
        install -dm755 "$out/share/myspell/dicts"
        ln -sv "$out/share/hunspell/${dictFileName}.dic" "$out/share/myspell/dicts/"
        ln -sv "$out/share/hunspell/${dictFileName}.aff" "$out/share/myspell/dicts/"
        # docs
        install -dm755 "$out/share/doc"
        install -m644 ${readmeFile} $out/share/doc/${pname}.txt
      '';
    };

  mkDictFromDicollecte =
    {
      shortName,
      shortDescription,
      longDescription,
      dictFileName,
      isDefault ? false,
    }:
    mkDict rec {
      inherit dictFileName;
      version = "5.3";
      pname = "hunspell-dict-${shortName}-dicollecte";
      readmeFile = "README_dict_fr.txt";
      src = fetchurl {
        url = "http://www.dicollecte.org/download/fr/hunspell-french-dictionaries-v${version}.zip";
        hash = "sha256-YEZkwHUUC4iQQKQVdeIRVp607s4uwM9nDOufKgkCRzE=";
      };
      meta = {
        inherit longDescription;
        description = "Hunspell dictionary for ${shortDescription} from Dicollecte";
        homepage = "https://www.dicollecte.org/home.php?prj=fr";
        license = lib.licenses.mpl20;
        maintainers = with lib.maintainers; [ renzo ];
        platforms = lib.platforms.all;
      };
      nativeBuildInputs = [ unzip ];
      sourceRoot = ".";
      unpackCmd = ''
        unzip $src ${dictFileName}.dic ${dictFileName}.aff ${readmeFile}
      '';
      postInstall = lib.optionalString isDefault ''
        for ext in aff dic; do
          ln -sv $out/share/hunspell/${dictFileName}.$ext $out/share/hunspell/fr_FR.$ext
          ln -sv $out/share/myspell/dicts/${dictFileName}.$ext $out/share/myspell/dicts/fr_FR.$ext
        done
      '';
    };

  mkDictFromWordlist =
    {
      shortName,
      shortDescription,
      srcFileName,
      dictFileName,
      src,
    }:
    mkDict rec {
      inherit src srcFileName dictFileName;
      version = "2018.04.16";
      pname = "hunspell-dict-${shortName}-wordlist";
      srcReadmeFile = "README_" + srcFileName + ".txt";
      readmeFile = "README_" + dictFileName + ".txt";
      meta = {
        description = "Hunspell dictionary for ${shortDescription} from Wordlist";
        homepage = "http://wordlist.aspell.net/";
        license = lib.licenses.bsd3;
        maintainers = with lib.maintainers; [ renzo ];
        platforms = lib.platforms.all;
      };
      nativeBuildInputs = [ unzip ];
      sourceRoot = ".";
      unpackCmd = ''
        unzip $src ${srcFileName}.dic ${srcFileName}.aff ${srcReadmeFile}
      '';
      postUnpack = ''
        mv ${srcFileName}.dic ${dictFileName}.dic || true
        mv ${srcFileName}.aff ${dictFileName}.aff || true
        mv ${srcReadmeFile} ${readmeFile}         || true
      '';
    };

  mkDictFromLinguistico =
    {
      shortName,
      shortDescription,
      dictFileName,
      src,
    }:
    mkDict rec {
      inherit src dictFileName;
      version = "2.4";
      pname = "hunspell-dict-${shortName}-linguistico";
      readmeFile = dictFileName + "_README.txt";
      meta = {
        description = "Hunspell dictionary for ${shortDescription}";
        homepage = "https://sourceforge.net/projects/linguistico/";
        license = lib.licenses.gpl3;
        maintainers = with lib.maintainers; [ renzo ];
        platforms = lib.platforms.all;
      };
      nativeBuildInputs = [ unzip ];
      sourceRoot = ".";
      prePatch = ''
        # Fix dic file empty lines (FS#22275)
        sed '/^\/$/d' -i ${dictFileName}.dic
      '';
      unpackCmd = ''
        unzip $src ${dictFileName}.dic ${dictFileName}.aff ${readmeFile}
      '';
    };

  mkDictFromXuxen =
    {
      shortName,
      srcs,
      shortDescription,
      longDescription,
      dictFileName,
    }:
    stdenv.mkDerivation {
      pname = "hunspell-dict-${shortName}-xuxen";
      version = "5-2015.11.10";

      inherit srcs;

      sourceRoot = ".";
      # Copy files stripping until first dash (path and hash)
      unpackCmd = "cp $curSrc \${curSrc##*-}";
      installPhase = ''
        # hunspell dicts
        install -dm755 "$out/share/hunspell"
        install -m644 ${dictFileName}.dic "$out/share/hunspell/"
        install -m644 ${dictFileName}.aff "$out/share/hunspell/"
        # myspell dicts symlinks
        install -dm755 "$out/share/myspell/dicts"
        ln -sv "$out/share/hunspell/${dictFileName}.dic" "$out/share/myspell/dicts/"
        ln -sv "$out/share/hunspell/${dictFileName}.aff" "$out/share/myspell/dicts/"
      '';

      meta = {
        homepage = "https://xuxen.eus/";
        description = shortDescription;
        longDescription = longDescription;
        license = lib.licenses.gpl2;
        maintainers = with lib.maintainers; [ zalakain ];
        platforms = lib.platforms.all;
      };
    };

  mkDictFromJ3e =
    {
      shortName,
      shortDescription,
      dictFileName,
    }:
    stdenv.mkDerivation rec {
      pname = "hunspell-dict-${shortName}-j3e";
      version = "20161207";

      src = fetchurl {
        url = "https://j3e.de/ispell/igerman98/dict/igerman98-${version}.tar.bz2";
        hash = "sha256-FylvA8X+pi127MUw6+gPatxDAnj1jUctwYQtcWEpYKg=";
      };

      nativeBuildInputs = [
        ispell
        perl
        hunspell
      ];

      dontBuild = true;

      installPhase = ''
        patchShebangs bin
        make hunspell/${dictFileName}.aff hunspell/${dictFileName}.dic
        # hunspell dicts
        install -dm755 "$out/share/hunspell"
        install -m644 hunspell/${dictFileName}.dic "$out/share/hunspell/"
        install -m644 hunspell/${dictFileName}.aff "$out/share/hunspell/"
        # myspell dicts symlinks
        install -dm755 "$out/share/myspell/dicts"
        ln -sv "$out/share/hunspell/${dictFileName}.dic" "$out/share/myspell/dicts/"
        ln -sv "$out/share/hunspell/${dictFileName}.aff" "$out/share/myspell/dicts/"
      '';

      meta = {
        homepage = "https://www.j3e.de/ispell/igerman98/index_en.html";
        description = shortDescription;
        license = with lib.licenses; [
          gpl2
          gpl3
        ];
        maintainers = with lib.maintainers; [ timor ];
        platforms = lib.platforms.all;
      };
    };

  mkDictFromLibreOffice =
    {
      shortName,
      shortDescription,
      dictFileName,
      license,
      readmeFile ? "README_${dictFileName}.txt",
      sourceRoot ? dictFileName,
    }:
    mkDict rec {
      pname = "hunspell-dict-${shortName}-libreoffice";
      version = "6.3.0.4";
      inherit dictFileName readmeFile;
      src = fetchFromGitHub {
        owner = "LibreOffice";
        repo = "dictionaries";
        rev = "libreoffice-${version}";
        hash = "sha256-w/iD26CfTLCMnYPxN1awkN911WOG6qMTRZwdmx9Y5JM=";
      };
      buildPhase = ''
        cp -a ${sourceRoot}/* .
      '';
      meta = {
        homepage = "https://wiki.documentfoundation.org/Development/Dictionaries";
        description = "Hunspell dictionary for ${shortDescription} from LibreOffice";
        license = license;
        maintainers = with lib.maintainers; [ vlaci ];
        platforms = lib.platforms.all;
      };
    };

in
rec {

  # ENGLISH

  en_US = en-us;
  en-us = mkDictFromWordlist {
    shortName = "en-us";
    shortDescription = "English (United States)";
    srcFileName = "en_US";
    dictFileName = "en_US";
    src = fetchurl {
      url = "mirror://sourceforge/wordlist/speller/2018.04.16/hunspell-en_US-2018.04.16.zip";
      hash = "sha256-Tv26ZDi5FqYcShKTOVL0WFZPLyrz25qzwn8yizezC6I=";
    };
  };

  en_US-large = en-us-large;
  en-us-large = mkDictFromWordlist {
    shortName = "en-us-large";
    shortDescription = "English (United States) Large";
    srcFileName = "en_US-large";
    dictFileName = "en_US";
    src = fetchurl {
      url = "mirror://sourceforge/wordlist/speller/2018.04.16/hunspell-en_US-large-2018.04.16.zip";
      hash = "sha256-DCeiU9p5xytZwSQfKpDEPuC/D3ldTo/OYuXuuPCTqfY=";
    };
  };

  en_CA = en-ca;
  en-ca = mkDictFromWordlist {
    shortName = "en-ca";
    shortDescription = "English (Canada)";
    srcFileName = "en_CA";
    dictFileName = "en_CA";
    src = fetchurl {
      url = "mirror://sourceforge/wordlist/speller/2018.04.16/hunspell-en_CA-2018.04.16.zip";
      hash = "sha256-h7BtaqQfQfWcHHyYQ65mIygkiWUo6DVjlSWI4I8ezhs=";
    };
  };

  en_CA-large = en-ca-large;
  en-ca-large = mkDictFromWordlist {
    shortName = "en-ca-large";
    shortDescription = "English (Canada) Large";
    srcFileName = "en_CA-large";
    dictFileName = "en_CA";
    src = fetchurl {
      url = "mirror://sourceforge/wordlist/speller/2018.04.16/hunspell-en_CA-large-2018.04.16.zip";
      hash = "sha256-CjrqynoxwowGbAzUme0+AR0zWCpgbFGmRdGavX3vAIg=";
    };
  };

  en_AU = en-au;
  en-au = mkDictFromWordlist {
    shortName = "en-au";
    shortDescription = "English (Australia)";
    srcFileName = "en_AU";
    dictFileName = "en_AU";
    src = fetchurl {
      url = "mirror://sourceforge/wordlist/speller/2018.04.16/hunspell-en_AU-2018.04.16.zip";
      hash = "sha256-xZn31CDdrBJ4W/E+zL8AfQTGo3hMlJxqLaDNQK814M4=";
    };
  };

  en_AU-large = en-au-large;
  en-au-large = mkDictFromWordlist {
    shortName = "en-au-large";
    shortDescription = "English (Australia) Large";
    srcFileName = "en_AU-large";
    dictFileName = "en_AU";
    src = fetchurl {
      url = "mirror://sourceforge/wordlist/speller/2018.04.16/hunspell-en_AU-large-2018.04.16.zip";
      hash = "sha256-z8Aj+6ckdgNzsCXB+yJD0SZEo6OxYM6FlmGCeRvhgZI=";
    };
  };

  en_GB-ise = en-gb-ise;
  en-gb-ise = mkDictFromWordlist {
    shortName = "en-gb-ise";
    shortDescription = "English (United Kingdom, 'ise' ending)";
    srcFileName = "en_GB-ise";
    dictFileName = "en_GB";
    src = fetchurl {
      url = "mirror://sourceforge/wordlist/speller/2018.04.16/hunspell-en_GB-ise-2018.04.16.zip";
      hash = "sha256-VLBOSvnSFNbNAfVHe9+lEKfFcN4xMVZ9VVzp7fYPj3o=";
    };
  };

  en_GB-ize = en-gb-ize;
  en-gb-ize = mkDictFromWordlist {
    shortName = "en-gb-ize";
    shortDescription = "English (United Kingdom, 'ize' ending)";
    srcFileName = "en_GB-ize";
    dictFileName = "en_GB";
    src = fetchurl {
      url = "mirror://sourceforge/wordlist/speller/2018.04.16/hunspell-en_GB-ize-2018.04.16.zip";
      hash = "sha256-+gpSEx7Do7c8wrQWh8JFAmsSnvkKFSc5A4C02rXxvOY=";
    };
  };

  en_GB-large = en-gb-large;
  en-gb-large = mkDictFromWordlist {
    shortName = "en-gb-large";
    shortDescription = "English (United Kingdom) Large";
    srcFileName = "en_GB-large";
    dictFileName = "en_GB";
    src = fetchurl {
      url = "mirror://sourceforge/wordlist/speller/2018.04.16/hunspell-en_GB-large-2018.04.16.zip";
      hash = "sha256-sZ5RqV2FwQO1RfnZpiH+v92M9wY1gTh0gDjEvUs/jfg=";
    };
  };

  # SPANISH

  es_ANY = es-any;
  es-any = mkDictFromRla {
    shortName = "es-any";
    shortDescription = "Spanish (any variant)";
    dictFileName = "es_ANY";
  };

  es_AR = es-ar;
  es-ar = mkDictFromRla {
    shortName = "es-ar";
    shortDescription = "Spanish (Argentina)";
    dictFileName = "es_AR";
  };

  es_BO = es-bo;
  es-bo = mkDictFromRla {
    shortName = "es-bo";
    shortDescription = "Spanish (Bolivia)";
    dictFileName = "es_BO";
  };

  es_CL = es-cl;
  es-cl = mkDictFromRla {
    shortName = "es-cl";
    shortDescription = "Spanish (Chile)";
    dictFileName = "es_CL";
  };

  es_CO = es-co;
  es-co = mkDictFromRla {
    shortName = "es-co";
    shortDescription = "Spanish (Colombia)";
    dictFileName = "es_CO";
  };

  es_CR = es-cr;
  es-cr = mkDictFromRla {
    shortName = "es-cr";
    shortDescription = "Spanish (Costa Rica)";
    dictFileName = "es_CR";
  };

  es_CU = es-cu;
  es-cu = mkDictFromRla {
    shortName = "es-cu";
    shortDescription = "Spanish (Cuba)";
    dictFileName = "es_CU";
  };

  es_DO = es-do;
  es-do = mkDictFromRla {
    shortName = "es-do";
    shortDescription = "Spanish (Dominican Republic)";
    dictFileName = "es_DO";
  };

  es_EC = es-ec;
  es-ec = mkDictFromRla {
    shortName = "es-ec";
    shortDescription = "Spanish (Ecuador)";
    dictFileName = "es_EC";
  };

  es_ES = es-es;
  es-es = mkDictFromRla {
    shortName = "es-es";
    shortDescription = "Spanish (Spain)";
    dictFileName = "es_ES";
  };

  es_GT = es-gt;
  es-gt = mkDictFromRla {
    shortName = "es-gt";
    shortDescription = "Spanish (Guatemala)";
    dictFileName = "es_GT";
  };

  es_HN = es-hn;
  es-hn = mkDictFromRla {
    shortName = "es-hn";
    shortDescription = "Spanish (Honduras)";
    dictFileName = "es_HN";
  };

  es_MX = es-mx;
  es-mx = mkDictFromRla {
    shortName = "es-mx";
    shortDescription = "Spanish (Mexico)";
    dictFileName = "es_MX";
  };

  es_NI = es-ni;
  es-ni = mkDictFromRla {
    shortName = "es-ni";
    shortDescription = "Spanish (Nicaragua)";
    dictFileName = "es_NI";
  };

  es_PA = es-pa;
  es-pa = mkDictFromRla {
    shortName = "es-pa";
    shortDescription = "Spanish (Panama)";
    dictFileName = "es_PA";
  };

  es_PE = es-pe;
  es-pe = mkDictFromRla {
    shortName = "es-pe";
    shortDescription = "Spanish (Peru)";
    dictFileName = "es_PE";
  };

  es_PR = es-pr;
  es-pr = mkDictFromRla {
    shortName = "es-pr";
    shortDescription = "Spanish (Puerto Rico)";
    dictFileName = "es_PR";
  };

  es_PY = es-py;
  es-py = mkDictFromRla {
    shortName = "es-py";
    shortDescription = "Spanish (Paraguay)";
    dictFileName = "es_PY";
  };

  es_SV = es-sv;
  es-sv = mkDictFromRla {
    shortName = "es-sv";
    shortDescription = "Spanish (El Salvador)";
    dictFileName = "es_SV";
  };

  es_UY = es-uy;
  es-uy = mkDictFromRla {
    shortName = "es-uy";
    shortDescription = "Spanish (Uruguay)";
    dictFileName = "es_UY";
  };

  es_VE = es-ve;
  es-ve = mkDictFromRla {
    shortName = "es-ve";
    shortDescription = "Spanish (Venezuela)";
    dictFileName = "es_VE";
  };

  # FRENCH

  fr-any = mkDictFromDicollecte {
    shortName = "fr-any";
    dictFileName = "fr-toutesvariantes";
    shortDescription = "French (any variant)";
    longDescription = ''
      Ce dictionnaire contient les nouvelles et les anciennes graphies des
      mots concernés par la réforme de 1990.
    '';
  };

  fr-classique = mkDictFromDicollecte {
    shortName = "fr-classique";
    dictFileName = "fr-classique";
    shortDescription = "French (classic)";
    longDescription = ''
      Ce dictionnaire est une extension du dictionnaire «Moderne» et propose
      en sus des graphies alternatives, parfois encore très usitées, parfois
      tombées en désuétude.
    '';
  };

  fr-moderne = mkDictFromDicollecte {
    shortName = "fr-moderne";
    dictFileName = "fr-moderne";
    shortDescription = "French (modern)";
    longDescription = ''
      Ce dictionnaire propose une sélection des graphies classiques et
      réformées, suivant la lente évolution de l’orthographe actuelle. Ce
      dictionnaire contient les graphies les moins polémiques de la réforme.
    '';
    isDefault = true;
  };

  fr-reforme1990 = mkDictFromDicollecte {
    shortName = "fr-reforme1990";
    dictFileName = "fr-reforme1990";
    shortDescription = "French (1990 reform)";
    longDescription = ''
      Ce dictionnaire ne connaît que les graphies nouvelles des mots concernés
      par la réforme de 1990.
    '';
  };

  # ITALIAN

  it_IT = it-it;
  it-it = mkDictFromLinguistico {
    shortName = "it-it";
    dictFileName = "it_IT";
    shortDescription = "Hunspell dictionary for 'Italian (Italy)' from Linguistico";
    src = fetchurl {
      url = "mirror://sourceforge/linguistico/italiano_2_4_2007_09_01.zip";
      hash = "sha256-LTf2hwQffu4wYBSRWnW4rD1DSCxe2fnZMoV0V87PLlU=";
    };
  };

  # BASQUE

  eu_ES = eu-es;
  eu-es = mkDictFromXuxen {
    shortName = "eu-es";
    dictFileName = "eu_ES";
    shortDescription = "Basque (Xuxen 5)";
    longDescription = ''
      Itxura berritzeaz gain, testuak zuzentzen laguntzeko zenbait hobekuntza
      egin dira Xuxen.eus-en. Lexikoari dagokionez, 18645 sarrera berri erantsi
      ditugu, eta proposamenak egiteko sistema ere aldatu dugu. Esate baterako,
      gaizki idatzitako hitz baten inguruko proposamenak eskuratzeko, euskaraz
      idaztean egiten ditugun akats arruntenak hartu dira kontuan. Sistemak
      ematen dituen proposamenak ordenatzeko, berriz, aipatutako irizpidea
      erabiltzeaz gain, Internetetik automatikoki eskuratutako euskarazko corpus
      bateko datuen arabera ordenatu daitezke emaitzak. Erabiltzaileak horrela
      ordenatu nahi baditu proposamenak, hautatu egin behar du aukera hori
      testu-kutxaren azpian dituen aukeren artean. Interesgarria da proposamenak
      ordenatzeko irizpide hori, hala sistemak formarik erabilienak proposatuko
      baitizkigu gutxiago erabiltzen direnen aurretik.
    '';
    srcs = [
      (fetchurl {
        url = "http://xuxen.eus/static/hunspell/eu_ES.aff";
        hash = "sha256-ArA689psW3TN7q+5/0VNpeqRppVAuMN+y0KrD6+Rgos=";
      })
      (fetchurl {
        url = "http://xuxen.eus/static/hunspell/eu_ES.dic";
        hash = "sha256-Y5WW7066T8GZgzx5pQE0xK/wcxA3/dKLpbvRk+VIgVM=";
      })
    ];
  };

  # HUNGARIAN

  hu_HU = hu-hu;
  hu-hu = mkDictFromLibreOffice {
    shortName = "hu-hu";
    dictFileName = "hu_HU";
    shortDescription = "Hungarian (Hungary)";
    license = with lib.licenses; [
      mpl20
      lgpl3
    ];
  };

  # SWEDISH

  sv_SE = sv-se;
  sv-se = mkDictFromDSSO {
    shortName = "sv-se";
    dictFileName = "sv_SE";
    shortDescription = "Swedish (Sweden)";
  };

  # Finlandian Swedish (hello Linus Torvalds)
  sv_FI = sv-fi;
  sv-fi = mkDictFromDSSO {
    shortName = "sv-fi";
    dictFileName = "sv_FI";
    shortDescription = "Swedish (Finland)";
  };

  # ESTONIAN

  et_EE = et-ee;
  et-ee = mkDict rec {
    pname = "hunspell-dict-et-ee";
    name = pname;
    version = "20030606";

    src = fetchzip {
      url = "http://www.meso.ee/~jjpp/speller/ispell-et_${version}.tar.gz";
      hash = "sha256-MVfKekzq2RKZONsz2Ey/xSRlh2bln46YO5UdGNkFdxk=";
    };

    dictFileName = "et_EE";
    readmeFile = "README";

    preInstall = ''
      mv latin-1/${dictFileName}.dic ./
      mv latin-1/${dictFileName}.aff ./
    '';
  };

  # GERMAN

  de_DE = de-de;
  de-de = mkDictFromJ3e {
    shortName = "de-de";
    shortDescription = "German (Germany)";
    dictFileName = "de_DE";
  };

  de_AT = de-at;
  de-at = mkDictFromJ3e {
    shortName = "de-at";
    shortDescription = "German (Austria)";
    dictFileName = "de_AT";
  };

  de_CH = de-ch;
  de-ch = mkDictFromJ3e {
    shortName = "de-ch";
    shortDescription = "German (Switzerland)";
    dictFileName = "de_CH";
  };

  # UKRAINIAN

  uk_UA = uk-ua;
  uk-ua = mkDict rec {
    pname = "hunspell-dict-uk-ua";
    version = "6.5.3";
    _version = "1727974630";

    src = fetchurl {
      url = "https://extensions.libreoffice.org/assets/downloads/521/${_version}/dict-uk_UA-${version}.oxt";
      hash = "sha256-c957WHJqaf/M2QrE2H3aIDAWGoQDnDl0na7sd+kUXNI=";
    };

    dictFileName = "uk_UA";
    readmeFile = "README_uk_UA.txt";
    nativeBuildInputs = [ unzip ];
    unpackCmd = ''
      unzip $src ${dictFileName}/{${dictFileName}.dic,${dictFileName}.aff,${readmeFile}}
    '';

    meta = {
      description = "Hunspell dictionary for Ukrainian (Ukraine) from LibreOffice";
      homepage = "https://extensions.libreoffice.org/extensions/ukrainian-spelling-dictionary-and-thesaurus/";
      license = lib.licenses.mpl20;
      maintainers = with lib.maintainers; [ dywedir ];
      platforms = lib.platforms.all;
    };
  };

  # UZBEK
  uz_UZ = uz-uz;
  uz-uz = mkDict rec {
    pname = "hunspell-dict-uz-uz";
    version = "0.1.0";

    src = fetchFromGitHub {
      owner = "uzbek-net";
      repo = "uz-hunspell";
      tag = version;
      hash = "sha256-EUYhnUWUy45AYGH+HoxaFFCBVnotsIm4GlpMBgnHxdo=";
    };

    shortName = "uz-uz";
    dictFileName = "uz_UZ";
    readmeFile = "README.md";

    meta = {
      description = "Hunspell dictionary for Uzbek";
      homepage = "https://github.com/uzbek-net/uz-hunspell";
      license = with lib.licenses; [
        gpl3Plus
      ];
      teams = [ lib.teams.uzinfocom ];
    };
  };

  # RUSSIAN

  ru_RU = ru-ru;
  ru-ru = mkDictFromLibreOffice {
    shortName = "ru-ru";
    dictFileName = "ru_RU";
    shortDescription = "Russian (Russian)";
    license = with lib.licenses; [
      mpl20
      lgpl3
    ];
  };

  # CZECH

  cs_CZ = cs-cz;
  cs-cz = mkDictFromLibreOffice {
    shortName = "cs-cz";
    dictFileName = "cs_CZ";
    shortDescription = "Czech (Czechia)";
    readmeFile = "README_cs.txt";
    license = with lib.licenses; [ gpl2 ];
  };

  # SLOVAK

  sk_SK = sk-sk;
  sk-sk = mkDictFromLibreOffice {
    shortName = "sk-sk";
    dictFileName = "sk_SK";
    shortDescription = "Slovak (Slovakia)";
    readmeFile = "README_sk.txt";
    license = with lib.licenses; [
      gpl2
      lgpl21
      mpl11
    ];
  };

  # DANISH

  da_DK = da-dk;
  da-dk = mkDict rec {
    pname = "hunspell-dict-da-dk";
    version = "2.5.189";

    src = fetchurl {
      url = "https://stavekontrolden.dk/dictionaries/da_DK/da_DK-${version}.oxt";
      hash = "sha256-6CTyExN2NssCBXDbQkRhuzxbwjh4MC+eBouI5yzgLEQ=";
    };

    shortName = "da-dk";
    shortDescription = "Danish (Danmark)";
    dictFileName = "da_DK";
    readmeFile = "README_da_DK.txt";
    nativeBuildInputs = [ unzip ];
    unpackCmd = ''
      unzip $src ${dictFileName}.dic ${dictFileName}.aff ${readmeFile} -d ${dictFileName}
    '';

    meta = {
      description = "Hunspell dictionary for Danish (Denmark) from Stavekontrolden";
      homepage = "https://github.com/jeppebundsgaard/stavekontrolden";
      license = with lib.licenses; [
        gpl2Only
        lgpl21Only
        mpl11
      ];
      maintainers = with lib.maintainers; [ louisdk1 ];
    };
  };

  # DUTCH

  nl_NL = nl_nl;
  nl_nl = mkDict rec {
    pname = "hunspell-dict-nl-nl";
    version = "2.20.19";

    src = fetchFromGitHub {
      owner = "OpenTaal";
      repo = "opentaal-hunspell";
      rev = version;
      hash = "sha256-/rYufNGkXWH7UQDa8ZI55JtP9LM+0j7Pad8zm2tFqko=";
    };

    preInstall = ''
      mv nl.aff nl_NL.aff
      mv nl.dic nl_NL.dic
    '';

    dictFileName = "nl_NL";
    readmeFile = "README.md";

    meta = {
      description = "Hunspell dictionary for Dutch (Netherlands) from OpenTaal";
      homepage = "https://www.opentaal.org/";
      license = with lib.licenses; [
        bsd3 # or
        cc-by-30
      ];
      maintainers = with lib.maintainers; [ artturin ];
    };
  };

  # HEBREW

  he_IL = he-il;
  he-il = mkDictFromLibreOffice {
    shortName = "he-il";
    dictFileName = "he_IL";
    shortDescription = "Hebrew (Israel)";
    readmeFile = "README_he_IL.txt";
    license = with lib.licenses; [ agpl3Plus ];
  };

  # THAI

  th_TH = th-th;
  th-th = mkDict {
    pname = "hunspell-dict-th-th";
    version = "experimental-2024-04-15";
    dictFileName = "th_TH";
    readmeFile = "README.md";
    src = fetchFromGitHub {
      owner = "SyafiqHadzir";
      repo = "Hunspell-TH";
      rev = "419eb32115b936da9c949e35b35c29b8187f6c93";
      hash = "sha256-aXjof5dcEoCmep3PtvVkBhcgcd2NtqUpUEu37wsi1Uk=";
    };
    meta = {
      description = "Hunspell dictionary for Central Thai (Thailand)";
      homepage = "https://github.com/SyafiqHadzir/Hunspell-TH";
      license = with lib.licenses; [ gpl3 ];
      maintainers = with lib.maintainers; [ toastal ]; # looking for a native speaker
      platforms = lib.platforms.all;
    };
  };

  # INDONESIA

  id_ID = id_id;
  id_id = mkDictFromLibreOffice {
    shortName = "id-id";
    dictFileName = "id_ID";
    sourceRoot = "id";
    shortDescription = "Bahasa Indonesia (Indonesia)";
    readmeFile = "README-dict.md";
    license = with lib.licenses; [
      lgpl21Only
      lgpl3Only
    ];
  };

  # CROATIAN

  hr_HR = hr-hr;
  hr-hr = mkDictFromLibreOffice {
    shortName = "hr-hr";
    dictFileName = "hr_HR";
    shortDescription = "Croatian (Croatia)";
    readmeFile = "README_hr_HR.txt";
    license = with lib.licenses; [
      gpl2Only
      lgpl21Only
      mpl11
    ];
  };

  # NORWEGIAN

  nb_NO = nb-no;
  nb-no = mkDictFromLibreOffice {
    shortName = "nb-no";
    dictFileName = "nb_NO";
    sourceRoot = "no";
    readmeFile = "README_hyph_NO.txt";
    shortDescription = "Norwegian Bokmål (Norway)";
    license = with lib.licenses; [ gpl2Only ];
  };

  nn_NO = nn-no;
  nn-no = mkDictFromLibreOffice {
    shortName = "nn-no";
    dictFileName = "nn_NO";
    sourceRoot = "no";
    readmeFile = "README_hyph_NO.txt";
    shortDescription = "Norwegian Nynorsk (Norway)";
    license = with lib.licenses; [ gpl2Only ];
  };

  # TOKI PONA

  tok = mkDict rec {
    pname = "hunspell-dict-tok";
    version = "20220829";
    dictFileName = "tok";
    readmeFile = "README.en.adoc";

    src = fetchzip {
      url = "https://github.com/somasis/hunspell-tok/releases/download/${version}/hunspell-tok-${version}.tar.gz";
      hash = "sha256-RiAODKXPUeIcf8IFcU6Tacehq5S8GYuPTuxEiN2CXD0=";
    };

    dontBuild = true;

    meta = {
      description = "Hunspell dictionary for Toki Pona";
      homepage = "https://github.com/somasis/hunspell-tok";
      license = with lib.licenses; [
        cc0
        publicDomain
        cc-by-sa-30
        cc-by-sa-40
      ];
      maintainers = with lib.maintainers; [ somasis ];
      platforms = lib.platforms.all;
    };
  };

  # POLISH

  pl_PL = pl-pl;
  pl-pl = mkDictFromLibreOffice {
    shortName = "pl-pl";
    dictFileName = "pl_PL";
    shortDescription = "Polish (Poland)";
    readmeFile = "README_en.txt";
    # the README doesn't specify versions of licenses :/
    license = with lib.licenses; [
      gpl2Plus
      lgpl2Plus
      mpl10
      asl20
      cc-by-sa-25
    ];
  };

  # PORTUGUESE

  pt_BR = pt-br;
  pt-br = mkDictFromLibreOffice {
    shortName = "pt-br";
    dictFileName = "pt_BR";
    shortDescription = "Portuguese (Brazil)";
    readmeFile = "README_pt_BR.txt";
    license = with lib.licenses; [ lgpl3 ];
  };

  pt_PT = pt-pt;
  pt-pt = mkDictFromLibreOffice {
    shortName = "pt-pt";
    dictFileName = "pt_PT";
    shortDescription = "Portuguese (Portugal)";
    readmeFile = "README_pt_PT.txt";
    license = with lib.licenses; [
      gpl2
      lgpl21
      mpl11
    ];
  };

  # PERSIAN

  fa_IR = fa-ir;
  fa-ir = mkDict {
    pname = "hunspell-dict-fa-ir";
    version = "experimental-2022-09-04";
    dictFileName = "fa-IR";
    readmeFile = "README.md";
    src = fetchFromGitHub {
      owner = "b00f";
      repo = "lilak";
      rev = "1a80a8e5c9377ac424d29ef20be894e250bc9765";
      hash = "sha256-xonnrclzgFEHdQ9g8ijm0bo9r5a5Y0va52NoJR5d8mo=";
    };
    nativeBuildInputs = [ python3 ];
    buildPhase = ''
      runHook preBuild
      mkdir build
      (cd src && python3 lilak.py)
      mv build/* ./
      # remove timestamp from file
      sed -i 's/^\(## *File Version[^,]*\),.*/\1/' fa-IR.aff
      runHook postBuild
    '';
    meta = {
      description = "Hunspell dictionary for Persian (Iran)";
      homepage = "https://github.com/b00f/lilak";
      license = lib.licenses.asl20;
      maintainers = with lib.maintainers; [ nix-julia ];
      platforms = lib.platforms.all;
    };
  };

  # ROMANIAN
  ro_RO = ro-ro;
  ro-ro = mkDict rec {
    pname = "hunspell-dict-ro-ro";
    version = "3.3.10";
    shortName = "ro-ro";
    dictFileName = "ro_RO";
    fileName = "${dictFileName}.${version}.zip";
    shortDescription = "Romanian (Romania)";
    readmeFile = "README";

    src = fetchurl {
      url = "mirror://sourceforge/rospell/${fileName}";
      hash = "sha256-fxKNZOoGyeZxHDCxGMCv7vsBTY8zyS2szfRVq6LQRRk=";
    };

    nativeBuildInputs = [ unzip ];
    unpackCmd = ''
      unzip $src ${dictFileName}.aff ${dictFileName}.dic ${readmeFile} -d ${dictFileName}
    '';

    meta = {
      description = "Hunspell dictionary for ${shortDescription} from rospell";
      homepage = "https://sourceforge.net/projects/rospell/";
      license = with lib.licenses; [ gpl2Only ];
      maintainers = with lib.maintainers; [ Andy3153 ];
    };
  };

  # Turkish
  tr_TR = tr-tr;
  tr-tr = mkDict {
    pname = "hunspell-dict-tr-tr";
    version = "1.1.1";

    src = fetchFromGitHub {
      owner = "tdd-ai";
      repo = "hunspell-tr";
      rev = "7302eca5f3652fe7ae3d3ec06c44697c97342b4e";
      hash = "sha256-r/I5T/1e7gcp2XZ4UvnpFmWMTsNqLZSCbkqPcgC13PE=";
    };

    dictFileName = "tr_TR";
    readmeFile = "README.md";

    meta = {
      description = "Hunspell dictionary for Turkish (Turkey) from tdd-ai";
      homepage = "https://github.com/tdd-ai/hunspell-tr/";
      license = lib.licenses.mpl20;
      maintainers = with lib.maintainers; [ samemrecebi ];
      platforms = lib.platforms.all;
    };
  };

  # GREEK

  el_GR = el-gr;
  el-gr = mkDictFromLibreOffice {
    shortName = "el-gr";
    dictFileName = "el_GR";
    shortDescription = "Greek (Greece)";
    readmeFile = "README_el_GR.txt";
    license = with lib.licenses; [
      mpl11
      gpl2
      lgpl21
    ];
  };

  # KOREAN
  ko_KR = ko-kr;
  ko-kr = mkDict rec {
    pname = "hunspell-dict-ko-kr";
    version = "0.7.94";

    src = fetchFromGitHub {
      owner = "spellcheck-ko";
      repo = "hunspell-dict-ko";
      rev = version;
      hash = "sha256-eHuNppqB536wHXftzDghpB3cM9CNFKW1z8f0SNkEiD8=";
    };

    dictFileName = "ko_KR";
    readmeFile = "README.md";

    nativeBuildInputs = [ (python3.withPackages (ps: [ ps.pyyaml ])) ];

    preInstall = ''
      mv ko.aff ko_KR.aff
      mv ko.dic ko_KR.dic
    '';

    meta = {
      description = "Hunspell dictionary for Korean (South Korea)";
      homepage = "https://github.com/spellcheck-ko/hunspell-dict-ko";
      license = with lib.licenses; [
        gpl2Plus
        lgpl21Plus
        mpl11
      ];
      maintainers = with lib.maintainers; [ honnip ];
    };
  };
}
