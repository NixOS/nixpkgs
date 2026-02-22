{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
buildGoModule (finalAttrs: {
  pname = "chatgpt";
  version = "1.3.5";

  src = fetchFromGitHub {
    owner = "j178";
    repo = "chatgpt";
    rev = "v${finalAttrs.version}";
    hash = "sha256-+U5fDG/t1x7F4h+D3rVdgvYICoQDH7dd5GUNOCkXw/Q=";
  };

  vendorHash = "sha256-/bL9RRqNlKLqZSaym9y5A+RUDrHpv7GBR6ubZkZMPS4=";

  subPackages = [ "cmd/chatgpt" ];

  meta = {
    description = "Interactive CLI for ChatGPT";
    homepage = "https://github.com/j178/chatgpt";
    license = lib.licenses.mit;
    mainProgram = "chatgpt";
    maintainers = with lib.maintainers; [ Ruixi-rebirth ];
  };
})
