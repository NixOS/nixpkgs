{
<<<<<<< HEAD
=======
  fetchFromGitHub,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  bashInteractive,
  jq,
  makeWrapper,
  p7zip,
  lib,
  stdenv,
<<<<<<< HEAD
  fetchzip,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

stdenv.mkDerivation rec {
  pname = "r2mod_cli";
<<<<<<< HEAD
  version = "1.3.3";

  src = fetchzip {
    url = "https://thunderstore.io/package/download/Foldex/r2mod_cli/${version}/";
    hash = "sha256-J7ybNZa44/H+AjQ7L949I3iClXoDwinl/ITMK/QsTR0=";
    extension = "zip";
    stripRoot = false;
=======
  version = "1.3.3.1";

  src = fetchFromGitHub {
    owner = "Foldex";
    repo = "r2mod_cli";
    rev = "v${version}";
    sha256 = "sha256-Y9ZffztxfGYiUSphqwhe3rTbnJ/vmGGi1pLml+1tLP8=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  buildInputs = [ bashInteractive ];

  nativeBuildInputs = [ makeWrapper ];

  makeFlags = [
    "DESTDIR="
    "PREFIX=$(out)"
  ];

  postInstall = ''
    wrapProgram $out/bin/r2mod --prefix PATH : "${
      lib.makeBinPath [
        jq
        p7zip
      ]
    }";
  '';

<<<<<<< HEAD
  meta = {
    description = "Risk of Rain 2 Mod Manager in Bash";
    homepage = "https://thunderstore.io/package/Foldex/r2mod_cli";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.reedrw ];
    mainProgram = "r2mod";
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    description = "Risk of Rain 2 Mod Manager in Bash";
    homepage = "https://github.com/foldex/r2mod_cli";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.reedrw ];
    mainProgram = "r2mod";
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
