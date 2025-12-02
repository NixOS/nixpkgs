{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "external-editor-revived";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "Frederick888";
    repo = "external-editor-revived";
    tag = "v${version}";
    sha256 = "sha256-K5agRpFJ8iqvPnx3IIMTvrkObT/GB962EtdvWf7Eq4w=";
  };

  cargoHash = "sha256-QYSsdEBNwjpR7lppyOcsc0F8ombBY+dlFRY1GO/D8so=";

  postInstall = ''
    mkdir -p "$out/lib/mozilla/native-messaging-hosts"
    substitute '${./native-messaging.json}' "$out/lib/mozilla/native-messaging-hosts/external_editor_revived.json" \
      --replace-fail "@OUT@" "$out"
  '';

  meta = with lib; {
    description = "Native messaging host for the Thunderbird addon allowing to edit mails in external programs";
    homepage = "https://github.com/Frederick888/external-editor-revived";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ mofrim ];
    mainProgram = "external-editor-revived";
  };
}
