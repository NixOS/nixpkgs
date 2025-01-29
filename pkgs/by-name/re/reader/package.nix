{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
let
  self = buildGoModule {
    pname = "reader";
    version = "0.4.6";

    src = fetchFromGitHub {
      owner = "mrusme";
      repo = "reader";
      tag = "v${self.version}";
      hash = "sha256-Z0mDRL02wZfmPRVDTDV85MqI5Ztctqen7PmOSW5Ee48=";
    };

    vendorHash = "sha256-6k6Zmwdpc4rBsahtU9nJmTUqfDZi6EeaJGVeLFzbY34=";

    meta = {
      description = "Lightweight tool offering better readability of web pages on the CLI";
      homepage = "https://github.com/mrusme/reader";
      changelog = "https://github.com/mrusme/reader/releases";
      license = lib.licenses.gpl3Plus;
      maintainers = with lib.maintainers; [ theobori ];
      mainProgram = "reader";
    };
  };
in
self
