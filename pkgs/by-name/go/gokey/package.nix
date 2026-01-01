{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "gokey";
<<<<<<< HEAD
  version = "0.2.0";
=======
  version = "0.1.3";

  patches = [ ./version.patch ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = "gokey";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-tJ9nCHhKPrw7SRGsqAlo/tf3tBLF63+CevEXggZADlE=";
  };

  vendorHash = "sha256-Btac9Oi8efqRy+OH49Na3Y6RGehHEmGfvDo2/7EWPL4=";

  meta = {
    homepage = "https://github.com/cloudflare/gokey";
    description = "Vault-less password store";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.confus ];
=======
    hash = "sha256-pvtRSWq/vXlyUShb61aiDlis9AiQnrA2PWycr1Zw0og=";
  };

  vendorHash = "sha256-qlP2tI6QQMjxP59zaXgx4mX9IWSrOKWmme717wDaUEc=";

  meta = with lib; {
    homepage = "https://github.com/cloudflare/gokey";
    description = "Vault-less password store";
    license = licenses.bsd3;
    maintainers = [ maintainers.confus ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "gokey";
  };
}
