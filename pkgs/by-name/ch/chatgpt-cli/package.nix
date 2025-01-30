{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
buildGoModule rec {
  pname = "chatgpt";
  version = "1.3.5";

  src = fetchFromGitHub {
    owner = "j178";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-+U5fDG/t1x7F4h+D3rVdgvYICoQDH7dd5GUNOCkXw/Q=";
  };

  vendorHash = "sha256-/bL9RRqNlKLqZSaym9y5A+RUDrHpv7GBR6ubZkZMPS4=";

  subPackages = [ "cmd/chatgpt" ];

  meta = with lib; {
    description = "Interactive CLI for ChatGPT";
    homepage = "https://github.com/j178/chatgpt";
    license = licenses.mit;
    mainProgram = "chatgpt";
    maintainers = with maintainers; [ Ruixi-rebirth ];
  };
}
