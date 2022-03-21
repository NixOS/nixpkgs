{ lib
, requireFile
, lang
, majorVersion ? null
}:

let allVersions = with lib; flip map
  # N.B. Versions in this list should be ordered from newest to oldest.
  [
    {
      version = "13.0.1";
      lang = "en";
      language = "English";
      sha256 = "3672a920c1b4af1afd480733f6d67665baf8258757dfe59a6ed6d7440cf26dba";
      installer = "Mathematica_13.0.1_BNDL_LINUX.sh";
    }
    {
      version = "13.0.0";
      lang = "en";
      language = "English";
      sha256 = "15bbad39a5995031325d1d178f63b00e71706d3ec9001eba6d1681fbc991d3e1";
      installer = "Mathematica_13.0.0_BNDL_LINUX.sh";
    }
    {
      version = "12.3.1";
      lang = "en";
      language = "English";
      sha256 = "51b9cab12fd91b009ea7ad4968a2c8a59e94dc55d2e6cc1d712acd5ba2c4d509";
      installer = "Mathematica_12.3.1_LINUX.sh";
    }
    {
      version = "12.3.0";
      lang = "en";
      language = "English";
      sha256 = "045df045f6e796ded59f64eb2e0f1949ac88dcba1d5b6e05fb53ea0a4aed7215";
      installer = "Mathematica_12.3.0_LINUX.sh";
    }
    {
      version = "12.2.0";
      lang = "en";
      language = "English";
      sha256 = "3b6676a203c6adb7e9c418a5484b037974287b5be09c64e7dfea74ddc0e400d7";
      installer = "Mathematica_12.2.0_LINUX.sh";
    }
    {
      version = "12.1.1";
      lang = "en";
      language = "English";
      sha256 = "02mk8gmv8idnakva1nc7r7mx8ld02lk7jgsj1zbn962aps3bhixd";
      installer = "Mathematica_12.1.1_LINUX.sh";
    }
    {
      version = "12.1.0";
      lang = "en";
      language = "English";
      sha256 = "15m9l20jvkxh5w6mbp81ys7mx2lx5j8acw5gz0il89lklclgb8z7";
      installer = "Mathematica_12.1.0_LINUX.sh";
    }
    {
      version = "12.0.0";
      lang = "en";
      language = "English";
      sha256 = "b9fb71e1afcc1d72c200196ffa434512d208fa2920e207878433f504e58ae9d7";
      installer = "Mathematica_12.0.0_LINUX.sh";
    }
    {
      version = "11.3.0";
      lang = "en";
      language = "English";
      sha256 = "0fcfe208c1eac8448e7be3af0bdb84370b17bd9c5d066c013928c8ee95aed10e";
      installer = "Mathematica_11.3.0_LINUX.sh";
    }
    {
      version = "11.2.0";
      lang = "ja";
      language = "Japanese";
      sha256 = "916392edd32bed8622238df435dd8e86426bb043038a3336f30df10d819b49b1";
      installer = "Mathematica_11.2.0_ja_LINUX.sh";
    }
  ]
  ({ version, lang, language, sha256, installer }: {
    inherit version lang;
    name = "mathematica-${version}" + optionalString (lang != "en") "-${lang}";
    src = requireFile {
      name = installer;
      message = ''
        This nix expression requires that ${installer} is
        already part of the store. Find the file on your Mathematica CD
        and add it to the nix store with nix-store --add-fixed sha256 <FILE>.
      '';
      inherit sha256;
    };
  });
minVersion =
  with lib;
  if majorVersion == null
  then elemAt (builtins.splitVersion (elemAt allVersions 0).version) 0
  else majorVersion;
maxVersion = toString (1 + builtins.fromJSON minVersion);
in
with lib;
findFirst (l: (l.lang == lang
               && l.version >= minVersion
               && l.version < maxVersion))
          (throw "Version ${minVersion} in language ${lang} not supported")
          allVersions
