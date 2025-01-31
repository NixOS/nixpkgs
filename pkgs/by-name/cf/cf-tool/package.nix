{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nix-update-script,
}:
buildGoModule rec {
  pname = "cf-tool";
  version = "202405140250";

  src = fetchFromGitHub {
    owner = "sempr";
    repo = "cf-tool";
    rev = version;
    hash = "sha256-D+mJJw1+ImCrFpsv8HmaAwWqjYvUWouh8mgQ7hJxMrc=";
  };

  vendorHash = "sha256-R+mzfH9f422+WTiwIbDoBeEc+YYbW3tisUPlqrnFWbg=";

  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Codeforces CLI (Submit, Parse, Test, etc.). Support Contests, Gym, Groups, acmsguru, Windows, macOS, Linux, 7 MB";
    homepage = "https://github.com/sempr/cf-tool";
    license = licenses.mit;
    maintainers = with maintainers; [ bot-wxt1221 ];
    mainProgram = "cf";
  };
}
