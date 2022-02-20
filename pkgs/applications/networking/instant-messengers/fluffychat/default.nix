{ lib
, fetchFromGitLab
, flutter
, olm
}:

flutter.mkFlutterApp rec {
  pname = "fluffychat";
  version = "1.2.0";

  vendorHash = "sha256-Qg0IlajbIl8e3BkKgn4O+mbZGvhfqr7XwllBLJQAA/I=";

  src = fetchFromGitLab {
    owner = "famedly";
    repo = "fluffychat";
    rev = "v${version}";
    hash = "sha256-PJH3jMQc6u9R6Snn+9rNN8t+8kt6l3Xt7zKPbpqj13E=";
  };

  buildInputs = [
    olm
  ];

  meta = with lib; {
    description = "Chat with your friends (matrix client)";
    homepage = "https://fluffychat.im/";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ mkg20001 ];
    platforms = platforms.linux;
  };
}
