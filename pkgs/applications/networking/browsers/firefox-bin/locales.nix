# map from a system locale to a locale supported by Mozilla Firefox using prefix matching

{ lib }:
let
  localeMap = [
    {
      sys = "ach";
      moz = "ach";
    }
    {
      sys = "af";
      moz = "af";
    }
    {
      sys = "an";
      moz = "an";
    }
    {
      sys = "ar";
      moz = "ar";
    }
    {
      sys = "ast";
      moz = "ast";
    }
    {
      sys = "az";
      moz = "az";
    }
    {
      sys = "be";
      moz = "be";
    }
    {
      sys = "bg";
      moz = "bg";
    }
    {
      sys = "bn";
      moz = "bn";
    }
    {
      sys = "br";
      moz = "br";
    }
    {
      sys = "bs";
      moz = "bs";
    }
    {
      sys = "ca_ES@valencia";
      moz = "ca-valencia";
    }
    {
      sys = "ca";
      moz = "ca";
    }
    {
      sys = "cak";
      moz = "cak";
    }
    {
      sys = "cs";
      moz = "cs";
    }
    {
      sys = "cy";
      moz = "cy";
    }
    {
      sys = "da";
      moz = "da";
    }
    {
      sys = "de";
      moz = "de";
    }
    {
      sys = "dsb";
      moz = "dsb";
    }
    {
      sys = "el";
      moz = "el";
    }
    {
      sys = "en_CA";
      moz = "en-CA";
    }
    {
      sys = "en_GB";
      moz = "en-GB";
    }
    {
      sys = "en_US";
      moz = "en-US";
    }
    {
      sys = "eo";
      moz = "eo";
    }
    {
      sys = "es_AR";
      moz = "es-AR";
    }
    {
      sys = "es_CL";
      moz = "es-CL";
    }
    {
      sys = "es_ES";
      moz = "es-ES";
    }
    {
      sys = "es_MX";
      moz = "es-MX";
    }
    {
      sys = "et";
      moz = "et";
    }
    {
      sys = "eu";
      moz = "eu";
    }
    {
      sys = "fa";
      moz = "fa";
    }
    {
      sys = "ff";
      moz = "ff";
    }
    {
      sys = "fi";
      moz = "fi";
    }
    {
      sys = "fr";
      moz = "fr";
    }
    {
      sys = "fy_NL";
      moz = "fy-NL";
    }
    {
      sys = "ga_IE";
      moz = "ga-IE";
    }
    {
      sys = "gd";
      moz = "gd";
    }
    {
      sys = "gl";
      moz = "gl";
    }
    {
      sys = "gn";
      moz = "gn";
    }
    {
      sys = "gu_IN";
      moz = "gu-IN";
    }
    {
      sys = "he";
      moz = "he";
    }
    {
      sys = "hi_IN";
      moz = "hi-IN";
    }
    {
      sys = "hr";
      moz = "hr";
    }
    {
      sys = "hsb";
      moz = "hsb";
    }
    {
      sys = "hu";
      moz = "hu";
    }
    {
      sys = "hy_AM";
      moz = "hy-AM";
    }
    {
      sys = "ia";
      moz = "ia";
    }
    {
      sys = "id";
      moz = "id";
    }
    {
      sys = "is";
      moz = "is";
    }
    {
      sys = "it";
      moz = "it";
    }
    {
      sys = "ja";
      moz = "ja";
    }
    {
      sys = "ka";
      moz = "ka";
    }
    {
      sys = "kab";
      moz = "kab";
    }
    {
      sys = "kk";
      moz = "kk";
    }
    {
      sys = "km";
      moz = "km";
    }
    {
      sys = "kn";
      moz = "kn";
    }
    {
      sys = "ko";
      moz = "ko";
    }
    {
      sys = "lij";
      moz = "lij";
    }
    {
      sys = "lt";
      moz = "lt";
    }
    {
      sys = "lv";
      moz = "lv";
    }
    {
      sys = "mk";
      moz = "mk";
    }
    {
      sys = "mr";
      moz = "mr";
    }
    {
      sys = "ms";
      moz = "ms";
    }
    {
      sys = "my";
      moz = "my";
    }
    {
      sys = "nb_NO";
      moz = "nb-NO";
    }
    {
      sys = "ne_NP";
      moz = "ne-NP";
    }
    {
      sys = "nl";
      moz = "nl";
    }
    {
      sys = "nn_NO";
      moz = "nn-NO";
    }
    {
      sys = "oc";
      moz = "oc";
    }
    {
      sys = "pa_IN";
      moz = "pa-IN";
    }
    {
      sys = "pl";
      moz = "pl";
    }
    {
      sys = "pt_BR";
      moz = "pt-BR";
    }
    {
      sys = "pt_PT";
      moz = "pt-PT";
    }
    {
      sys = "rm";
      moz = "rm";
    }
    {
      sys = "ro";
      moz = "ro";
    }
    {
      sys = "ru";
      moz = "ru";
    }
    {
      sys = "sco";
      moz = "sco";
    }
    {
      sys = "si";
      moz = "si";
    }
    {
      sys = "sk";
      moz = "sk";
    }
    {
      sys = "sl";
      moz = "sl";
    }
    {
      sys = "son";
      moz = "son";
    }
    {
      sys = "sq";
      moz = "sq";
    }
    {
      sys = "sr";
      moz = "sr";
    }
    {
      sys = "sv_SE";
      moz = "sv-SE";
    }
    {
      sys = "szl";
      moz = "szl";
    }
    {
      sys = "ta";
      moz = "ta";
    }
    {
      sys = "te";
      moz = "te";
    }
    {
      sys = "th";
      moz = "th";
    }
    {
      sys = "tl";
      moz = "tl";
    }
    {
      sys = "tr";
      moz = "tr";
    }
    {
      sys = "trs";
      moz = "trs";
    }
    {
      sys = "uk";
      moz = "uk";
    }
    {
      sys = "ur";
      moz = "ur";
    }
    {
      sys = "uz";
      moz = "uz";
    }
    {
      sys = "vi";
      moz = "vi";
    }
    {
      sys = "xh";
      moz = "xh";
    }
    {
      sys = "xpi";
      moz = "xpi";
    }
    {
      sys = "zh_CN";
      moz = "zh-CN";
    }
    {
      sys = "zh_TW";
      moz = "zh-TW";
    }
  ];

  isPrefixOf = prefix: string:
    builtins.substring 0 (builtins.stringLength prefix) string == prefix;

  localeMatches = locale: source: (isPrefixOf source.sys locale);

in {
  mozLocale = sysLocale:
    (lib.findFirst (localeMatches sysLocale) { moz = "en_US"; } localeMap).moz;
}
