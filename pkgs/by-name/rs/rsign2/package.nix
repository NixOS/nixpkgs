{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "rsign2";
  version = "0.6.5";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-cjucecEg5ERPsiaDuGESf2u9RTYHpQmHwWPnx1ask0I=";
  };

  cargoHash = "sha256-pVEv7FST/jm4YNoU8T48/an2MsqboHXc+PMPYf13pKQ=";

<<<<<<< HEAD
  meta = {
    description = "Command-line tool to sign files and verify signatures";
    homepage = "https://github.com/jedisct1/rsign2";
    license = lib.licenses.mit;
=======
  meta = with lib; {
    description = "Command-line tool to sign files and verify signatures";
    homepage = "https://github.com/jedisct1/rsign2";
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
    mainProgram = "rsign";
  };
}
