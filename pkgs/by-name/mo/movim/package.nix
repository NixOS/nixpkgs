{ lib
, fetchFromGitHub
, php
, phpCfg ? null
, withPgsql ? true # “strongly recommended” according to docs
, withMysql ? false
}:

php.buildComposerProject (finalAttrs: {
  pname = "movim";
  version = "0.23";

  src = fetchFromGitHub {
    owner = "movim";
    repo = "movim";
    rev = "v${finalAttrs.version}";
    hash = "sha256-9MBe2IRYxvUuCc5m7ajvIlBU7YVm4A3RABlOOIjpKoM=";
  };

  php = php.buildEnv ({
    extensions = ({ all, enabled }:
      enabled
        ++ (with all; [ curl dom gd imagick mbstring pdo simplexml ])
        ++ lib.optionals withPgsql (with all; [ pdo_pgsql pgsql ])
        ++ lib.optionals withMysql (with all; [ mysqli mysqlnd pdo_mysql ])
    );
  } // lib.optionalAttrs (phpCfg != null) {
    extraConfig = phpCfg;
  });

  # no listed license
  # pinned commonmark
  composerStrictValidation = false;

  vendorHash = "sha256-PBoJbVuF0Qy7nNlL4yx446ivlZpPYNIai78yC0wWkCM=";

  meta = {
    description = "a federated blogging & chat platform that acts as a web front end for the XMPP protocol";
    homepage = "https://movim.eu";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ toastal ];
  };
})
