{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  perlPackages,
}:
stdenv.mkDerivation {
  pname = "asciiquarium-transparent";
  version = "unstable-2023-02-19";
  src = fetchFromGitHub {
    owner = "nothub";
    repo = "asciiquarium";
    rev = "653cd99a611080c776d18fc7991ae5dd924c72ce";
    hash = "sha256-72LRFydbObFDXJllmlRjr5O8qjDqtlp3JunE3kwb5aU=";
  };
  nativeBuildInputs = [makeWrapper];
  buildInputs = [perlPackages.perl];
  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp asciiquarium $out/bin/asciiquarium
    wrapProgram $out/bin/asciiquarium --set PERL5LIB ${perlPackages.makeFullPerlPath [perlPackages.TermAnimation]}
    runHook postInstall
  '';
  meta = with lib; {
    description = "An aquarium/sea animation in ASCII art (with option of transparent background)";
    mainProgram = "asciiquarium";
    homepage = "https://github.com/nothub/asciiquarium";
    license = with licenses; [gpl2Only];
    platforms = platforms.unix;
    maintainers = with maintainers; [quantenzitrone];
  };
}
