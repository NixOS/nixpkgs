{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  perl,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "asciiquarium-transparent";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "nothub";
    repo = "asciiquarium";
    rev = "${finalAttrs.version}";
    hash = "sha256-zQyVIfwmhF3WsCeIZLwjDufvKzAfjLxaK2s7WTedqCg=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ perl ];
  installPhase = ''
    runHook preInstall
    install -Dm555 asciiquarium -t $out/bin
    wrapProgram $out/bin/asciiquarium \
      --set PERL5LIB ${with perl.pkgs; makeFullPerlPath [ TermAnimation ]}
    runHook postInstall
  '';

  meta = {
    description = "An aquarium/sea animation in ASCII art (with option of transparent background)";
    homepage = "https://github.com/nothub/asciiquarium";
    license = lib.licenses.gpl2Only;
    mainProgram = "asciiquarium";
    maintainers = with lib.maintainers; [ quantenzitrone ];
    platforms = perl.meta.platforms;
  };
})
