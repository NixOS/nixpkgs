{ lib, ... }:
{
  name = "glibLocales-custom-builds";
  meta.maintainers = with lib.maintainers; [ doronbehar ];

  nodes = {
    nonUTF8Charset = {
      i18n = {
        defaultLocale = "en_US";
        defaultCharset = "ISO-8859-1";
      };
    };
    extraLocales1 = {
      i18n = {
        defaultLocale = "en_US.UTF-8";
        extraLocales = [
          "nl_NL.UTF-8/UTF-8"
        ];
      };
    };
    extraLocaleSettings = {
      i18n = {
        defaultLocale = "en_US.UTF-8";
        extraLocaleSettings = {
          LC_MESSAGES = "en_US.UTF-8";
          LC_TIME = "de_DE.UTF-8";
        };
      };
    };
    localeCharsets = {
      i18n = {
        defaultLocale = "en_US.UTF-8";
        extraLocaleSettings = {
          LC_TIME = "de_DE";
        };
        localeCharsets = {
          LC_TIME = "ISO-8859-1";
        };
      };
    };
    Csimple = {
      i18n = {
        defaultLocale = "C";
      };
    };
    CnonDefault = {
      i18n = {
        defaultLocale = "en_US.UTF-8";
        extraLocaleSettings = {
          LC_COLLATE = "C";
          LC_MESSAGES = "C";
          LC_TIME = "C";
        };
      };
    };
  };
  testScript =
    { nodes, ... }:
    lib.pipe nodes [
      builtins.attrNames
      (map (node: ''
        ${node}.copy_from_vm(
            ${node}.succeed("readlink -f /etc/locale.conf").strip(),
            "${node}"
        )
      ''))
      (lib.concatStringsSep "\n")
    ];
}
