{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "tango";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "masakichi";
    repo = "tango";
    rev = "v${version}";
    hash = "sha256-e/M2iRm/UwfnRVnMo1PmQTkz4IGTxnsCXNSSUkhsiHk=";
  };

  vendorHash = "sha256-83nKtiEy1na1HgAQcbTEfl+0vGg6BkCLBK1REN9fP+k=";

  meta = with lib; {
    description = "A local command-line Japanese dictionary tool using yomichan's dictionary files";
    homepage = "https://github.com/masakichi/tango";
    license = licenses.mit;
    maintainers = with maintainers; [ donovanglover ];
    mainProgram = "tango";
  };
}
