{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
  libiconv,
}:

rustPlatform.buildRustPackage rec {
  pname = "fselect";
<<<<<<< HEAD
  version = "0.9.2";
=======
  version = "0.9.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "jhspetersson";
    repo = "fselect";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-S9WlDpa9Qe3GVVC/L5KAyekH1NegdDttJ6HH5rwI6Dk=";
  };

  cargoHash = "sha256-q7FBKzVH2EtP2PjrU8bvQTrzvMZ0T+Cgk7o+lpyuTPc=";
=======
    sha256 = "sha256-6TKCasE+Cks/f716mtEnPOvjcbQ7weipbGfFwnBYXJk=";
  };

  cargoHash = "sha256-2DmfbQWyU+1vNKxZvDw92Rh5rxFifeKEglZSV2YNfdA=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeBuildInputs = [ installShellFiles ];
  buildInputs = lib.optional stdenv.hostPlatform.isDarwin libiconv;

  postInstall = ''
    installManPage docs/fselect.1
  '';

<<<<<<< HEAD
  meta = {
    description = "Find files with SQL-like queries";
    homepage = "https://github.com/jhspetersson/fselect";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "Find files with SQL-like queries";
    homepage = "https://github.com/jhspetersson/fselect";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = with maintainers; [
      Br1ght0ne
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      matthiasbeyer
    ];
    mainProgram = "fselect";
  };
}
