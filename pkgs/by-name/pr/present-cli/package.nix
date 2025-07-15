{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage {
  pname = "present";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "terror";
    repo = "present";
    rev = "43c10253dc31038614eba5824588dbf2716212d6A";
    sha256 = "aMy8Qn1kUM7jmvD9nGjBk1XXQF1rTLfnPDJOh9d4uIg=";
  };

  cargoHash = "sha256-rLLhZL8WQs68+nwCrJ9Dej3T1JU9t+ZrBhSMxAdOfbw=";

  # required for tests
  postPatch = ''
    patchShebangs bin/get_version
  '';

  doCheck = true;

  meta = with lib; {
    description = "Script interpolation engine for markdown documents";
    homepage = "https://github.com/terror/present/";
    license = licenses.cc0;
    maintainers = with maintainers; [ cameronfyfe ];
    mainProgram = "present";
  };
}
