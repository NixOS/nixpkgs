{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "firefox-sync-client";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "Mikescher";
    repo = "firefox-sync-client";
    rev = "v${version}";
    hash = "sha256-tzYuYSifV/a9SPb5KyabhQ29ByXuAgQgi3t0VMHVSH8=";
  };

  vendorHash = "sha256-kDh/5SOwKPYl9sC9W17bnzG73fGI5iX6lSjcB3IjOss=";

  meta = {
    description = "Commandline-utility to list/view/edit/delete entries in a firefox-sync account";
    homepage = "https://github.com/Mikescher/firefox-sync-client";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ambroisie ];
    mainProgram = "ffsclient";
  };
}
