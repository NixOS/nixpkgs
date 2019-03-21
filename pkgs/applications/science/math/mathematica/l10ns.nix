{ lib, requireFile }:

with lib;
{
  l10ns = flip map
  [
    {
      version = "11.3.0";
      lang = "en";
      language = "English";
      sha256 = "0fcfe208c1eac8448e7be3af0bdb84370b17bd9c5d066c013928c8ee95aed10e";
    }
    {
      version = "11.2.0";
      lang = "ja";
      language = "Japanese";
      sha256 = "916392edd32bed8622238df435dd8e86426bb043038a3336f30df10d819b49b1";
    }
  ]
  ({ version, lang, language, sha256 }: {
    inherit version lang;
    name = "mathematica-${version}" + optionalString (lang != "en") "-${lang}";
    src = requireFile rec {
      name = "Mathematica_${version}" + optionalString (lang != "en") "_${language}" + "_LINUX.sh";
      message = ''
        This nix expression requires that ${name} is
        already part of the store. Find the file on your Mathematica CD
        and add it to the nix store with nix-store --add-fixed sha256 <FILE>.
      '';
      inherit sha256;
    };
  });
}
