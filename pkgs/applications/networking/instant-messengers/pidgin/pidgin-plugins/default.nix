{
  lib,
  newScope,
  pidgin,
  texliveBasic,
  config,
}:

lib.makeScope newScope (
  self:
  let
    callPackage = self.callPackage;
  in
  {
    pidgin = callPackage ../. {
      withOpenssl = config.pidgin.openssl or true;
      withGnutls = config.pidgin.gnutls or false;
      plugins = [ ];
    };

    pidginPackages = self;

    pidgin-indicator = callPackage ./pidgin-indicator { };

    pidgin-latex = callPackage ./pidgin-latex {
      texLive = texliveBasic;
    };

    pidgin-carbons = callPackage ./carbons { };

    pidgin-xmpp-receipts = callPackage ./pidgin-xmpp-receipts { };

    pidgin-otr = callPackage ./otr { };

    pidgin-osd = callPackage ./pidgin-osd { };

    pidgin-sipe = callPackage ./sipe { };

    pidgin-window-merge = callPackage ./window-merge { };

    purple-discord = callPackage ./purple-discord { };

    purple-googlechat = callPackage ./purple-googlechat { };

    purple-lurch = callPackage ./purple-lurch { };

    purple-mm-sms = callPackage ./purple-mm-sms { };

    purple-plugin-pack = callPackage ./purple-plugin-pack { };

    purple-slack = callPackage ./purple-slack { };

    purple-xmpp-http-upload = callPackage ./purple-xmpp-http-upload { };

    tdlib-purple = callPackage ./tdlib-purple { };
  }
  // lib.optionalAttrs config.allowAliases {
    purple-matrix = throw "'pidginPackages.purple-matrix' has been unmaintained since April 2022, so it was removed.";
    pidgin-skypeweb = throw "'pidginPackages.pidgin-skypeweb' has been removed since Skype was shut down in May 2025.";
    purple-hangouts = throw "'pidginPackages.purple-hangouts' has been removed as Hangouts Classic is obsolete and migrated to Google Chat.";
    pidgin-msn-pecan = throw "'pidginPackages.pidgin-msn-pecan' has been removed as it's unmaintained upstream and doesn't work with escargot";
    pidgin-mra = throw "'pidginPackages.pidgin-mra' has been removed since mail.ru agent service has stopped functioning in 2024.";
    purple-facebook = throw "'pidginPackages.purple-facebook' has been removed as it is unmaintained and doesn't support e2ee enforced by facebook.";
    pidgin-opensteamworks = throw "'pidginPackages.pidgin-opensteamworks' has been removed as it is unmaintained and no longer works with Steam.";
    purple-vk-plugin = throw "'pidginPackages.purple-vk-plugin' has been removed as upstream repository was deleted and no active forks are found.";
  }
)
