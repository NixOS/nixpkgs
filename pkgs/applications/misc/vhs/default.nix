{ stdenvNoCC, callPackage, lib, fetchFromGitHub }:

let
  pname = "vhs";
  version = "0.3.0";

  meta = with lib; {
    description = "A tool for generating terminal GIFs with code";
    homepage = "https://github.com/charmbracelet/vhs";
    changelog = "https://github.com/charmbracelet/vhs/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ maaslalani penguwin ];
  };

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-62FS/FBhQNpj3dAfKfIUKY+IJeeaONzqRu7mG49li+o";
  };

  vendorHash = "sha256-+BLZ+Ni2dqboqlOEjFNF6oB/vNDlNRCb6AiDH1uSsLw";

in

if stdenvNoCC.isDarwin
then callPackage ./darwin.nix { inherit pname version meta src vendorHash; }
else callPackage ./linux.nix { inherit pname version meta src vendorHash; }
