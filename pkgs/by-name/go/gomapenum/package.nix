{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gomapenum";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "nodauf";
    repo = "GoMapEnum";
    rev = "v${version}";
    sha256 = "sha256-a0JpHk5pUe+MkcmJl871JwkOfFDg3S4yOzFIeXCReLE=";
  };

  vendorHash = "sha256-5C0dDY/42H8oHNdQaKYiuqpi2QqqgHC7VMO/0kFAofY=";

  postInstall = ''
    mv $out/bin/src $out/bin/$pname
  '';

  meta = with lib; {
    description = "Tools for user enumeration and password bruteforce";
    mainProgram = "gomapenum";
    homepage = "https://github.com/nodauf/GoMapEnum";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
