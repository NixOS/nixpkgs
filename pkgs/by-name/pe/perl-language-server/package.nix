{
  lib,
  makeBinaryWrapper,
  perlPackages,
  stdenvNoCC,
}:

let
  inherit (perlPackages) perl PerlLanguageServer PerlTidy;
in
stdenvNoCC.mkDerivation {
  pname = "perl-language-server";
  inherit (PerlLanguageServer) version;

  __structuredAttrs = true;
  strictDeps = true;

  dontUnpack = true;

  nativeBuildInputs = [ makeBinaryWrapper ];

  # PerlTidy is suffixed so that a perltidy already on the PATH of the user wins
  installPhase = ''
    runHook preInstall

    makeWrapper ${lib.getExe perl} "$out"/bin/perl-language-server \
      --prefix PERL5LIB : ${perlPackages.makeFullPerlPath [ PerlLanguageServer ]} \
      --suffix PATH : ${lib.makeBinPath [ PerlTidy ]} \
      --add-flags "-MPerl::LanguageServer -e Perl::LanguageServer::run --"

    runHook postInstall
  '';

  meta = {
    description = "Language Server for Perl";
    homepage = "https://github.com/richterger/Perl-LanguageServer";
    changelog = "https://github.com/richterger/Perl-LanguageServer/blob/V${PerlLanguageServer.version}/Changes.pod";
    inherit (PerlLanguageServer.meta) license platforms;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "perl-language-server";
  };
}
