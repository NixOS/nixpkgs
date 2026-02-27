{
  fetchFromGitHub,
  lib,
  makeBinaryWrapper,
  perl,
  perlPackages,
}:

perlPackages.buildPerlPackage rec {
  pname = "perl-language-server";
  version = "2.6.2";

  src = fetchFromGitHub {
    owner = "richterger";
    repo = "Perl-LanguageServer";
    tag = "V${version}";
    hash = "sha256-sd3q6QONg3uNiASi+iSZJI/mTAENRZZI3FPtegjkMrc=";
  };

  nativeBuildInputs = [ makeBinaryWrapper ];
  buildInputs = with perlPackages; [
    AnyEvent
    AnyEventAIO
    ClassRefresh
    CompilerLexer
    Coro
    DataDump
    IOAIO
    JSON
    Moose
    PadWalker
    ScalarListUtils
  ];

  doCheck = false; # Flaky due to Coro/AnyEvent/IO::AIO in sandbox

  postInstall = ''
    mainProgramPath="$out"/bin/${meta.mainProgram}
    mkdir -p "$out"/bin
    cat > "$mainProgramPath" <<'EOF'
    #!${lib.getExe perl}
    use strict;
    use warnings;
    use Perl::LanguageServer;
    Perl::LanguageServer->run(@ARGV);
    EOF

    chmod +x "$mainProgramPath"
    wrapProgram "$mainProgramPath" \
      --prefix PERL5LIB : "${perlPackages.makeFullPerlPath buildInputs}" \
      --prefix PERL5LIB : "$out/lib/perl5/site_perl/5.42.0"
  '';

  meta = {
    description = "Language Server for Perl";
    homepage = "https://github.com/richterger/Perl-LanguageServer";
    changelog = "https://github.com/richterger/Perl-LanguageServer/blob/${src.tag}/Changes.pod";
    license = lib.licenses.artistic2;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "perl-language-server";
    platforms = lib.platforms.all;
  };
}
