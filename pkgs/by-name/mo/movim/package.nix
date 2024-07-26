{ lib
, fetchFromGitHub
, php
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

  php = php.buildEnv {
    extensions = ({ all, enabled }:
      enabled
      ++ (with all; [ curl dom gd imagick mbstring ])
      ++ lib.optional withPgsql all.pgsql
      ++ lib.optional withMysql all.mysqli
    );
  };

  # no listed license
  # pinned commonmark
  composerStrictValidation = false;

  vendorHash = "sha256-PBoJbVuF0Qy7nNlL4yx446ivlZpPYNIai78yC0wWkCM=";

  meta = {
    description = "a federated blogging & chat platform that acts as a web front end for the XMPP protocol";
    homepage = "https://movim.eu";
    license = lib.licenses.agpl3;
    maintainers = with lib.maintainers; [ toastal ];
  };
})
