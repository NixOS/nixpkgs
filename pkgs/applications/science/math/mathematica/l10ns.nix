{ lib, requireFile }:

with lib;
{
  l10ns = flip map
  [
    {
      version = "11.2.0";
      lang = "en";
      language = "English";
      sha256 = "4a1293cc1c404303aa1cab1bd273c7be151d37ac5ed928fbbb18e9c5ab2d8df9";
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
