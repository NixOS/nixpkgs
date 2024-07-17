{
  buildGoModule,
  lib,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "cntb";
  version = "1.4.8";

  src = fetchFromGitHub {
    owner = "contabo";
    repo = "cntb";
    rev = version;
    hash = "sha256-Cj1PO82JeztThFAHR4/8UyqKrodgxBqVDMDsun3iGDo=";
  };

  subPackages = [ "." ];

  vendorHash = "sha256-4PhLUUtlnRh2dKkeVD7rZDDVP0eTDVAohvLLftQxQyE=";

  meta = with lib; {
    description = "CLI tool for managing your products from Contabo like VPS and VDS";
    mainProgram = "cntb";
    homepage = "https://github.com/contabo/cntb";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ aciceri ];
  };
}
