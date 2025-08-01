{
  lib,
  stdenv,
  fetchFromGitHub,
  perl,
  perlPackages,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "7z2hashcat";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "philsmd";
    repo = "7z2hashcat";
    rev = finalAttrs.version;
    hash = "sha256-BmpO2VLcuUtQaN4qmLm0YQEfK5iE+2hw4k6uBbwcFS4=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs = [
    perl
  ];

  installPhase = ''
    runHook preInstall

    install -D 7z2hashcat.pl $out/bin/7z2hashcat
    wrapProgram $out/bin/7z2hashcat \
      --set PERL5LIB "${perlPackages.makePerlPath [ perlPackages.CompressRawLzma ]}" \

    runHook postInstall
  '';

  meta = {
    changelog = "https://github.com/philsmd/7z2hashcat/releases/tag/${finalAttrs.version}";
    description = "Extract hashcat hashes from password-protected .7z archives (and .sfx files)";
    homepage = "https://github.com/philsmd/7z2hashcat";
    license = lib.licenses.publicDomain;
    mainProgram = "7z2hashcat";
    maintainers = with lib.maintainers; [ emilytrau ];
    platforms = lib.platforms.unix;
  };
})
