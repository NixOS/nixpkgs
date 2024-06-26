{
  lib,
  melpaBuild,
  fetchFromGitHub,
  emacs,
  writeText,
}:

let
  rev = "519bfd868f206ed2fc538a57cdb631c4fec3c93e";
in
melpaBuild {
  pname = "beancount";
  version = "20230205.436";

  src = fetchFromGitHub {
    owner = "beancount";
    repo = "beancount-mode";
    inherit rev;
    hash = "sha256-nTEXJdPEPZpNm06uYvRxLuiOHmsiIgMLerd//dA0+KQ=";
  };

  commit = rev;

  recipe = writeText "recipe" ''
    (beancount :repo "beancount/beancount-mode" :fetcher github)
  '';

  meta = {
    homepage = "https://github.com/beancount/beancount-mode";
    description = "Emacs major-mode to work with Beancount ledger files";
    maintainers = with lib.maintainers; [ polarmutex ];
    license = lib.licenses.gpl3Only;
    inherit (emacs.meta) platforms;
  };
}
