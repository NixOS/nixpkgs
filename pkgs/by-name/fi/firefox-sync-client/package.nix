{ buildGoModule
, fetchFromGitHub
, lib
, nix-update-script
}:

buildGoModule rec {
  pname = "firefox-sync-client";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "Mikescher";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-3r1pKLOO+q8+6mn8un6u8OM49p7DlOhFu9Fe/qqwsXw=";
  };

  vendorHash = "sha256-MYetPdnnvIBzrYrA+eM9z1P3+P5FumYKH+brvvlwkm4=";

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Commandline-utility to list/view/edit/delete entries in a firefox-sync account.";
    homepage = "https://github.com/Mikescher/firefox-sync-client";
    license = licenses.asl20;
    maintainers = [ maintainers.skamdart ];
    mainProgram = "ffsclient";
  };
}
