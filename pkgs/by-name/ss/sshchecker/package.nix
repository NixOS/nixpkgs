{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "sshchecker";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "lazytools";
    repo = "sshchecker";
    rev = "v${version}";
    hash = "sha256-QMc64ynPLHQGsmDOsoChgmqmpRDyMYmmSAPwAEFBK40=";
  };

  vendorHash = "sha256-U5nZbo2iSKP3BnxT4lkR75QutcxZB5YLzXxT045TDaY=";

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Dedicated SSH brute-forcing tool";
    mainProgram = "sshchecker";
    longDescription = ''
      sshchecker is a fast dedicated SSH brute-forcing tool to check
      SSH login on the giving IP list.
    '';
    homepage = "https://github.com/lazytools/sshchecker";
<<<<<<< HEAD
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
=======
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
