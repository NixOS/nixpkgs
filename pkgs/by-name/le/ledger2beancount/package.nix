{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  perlPackages,
  beancount,
}:

let
  perlDeps = with perlPackages; [
    DateCalc
    DateTimeFormatStrptime
    enum
    FileBaseDir
    GetoptLongDescriptive
    ListMoreUtils
    RegexpCommon
    StringInterpolate
    YAMLLibYAML
  ];

in
stdenv.mkDerivation rec {
  pname = "ledger2beancount";
  version = "2.7";

  src = fetchFromGitHub {
    owner = "beancount";
    repo = "ledger2beancount";
    rev = version;
    sha256 = "sha256-2LIP3ljK1HMAwjk2ueIf9pFL+UUnGDgx9GYNtRztdFY=";
  };

  dontBuild = true;

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [
    perlPackages.perl
    beancount
  ] ++ perlDeps;

  makeFlags = [ "prefix=$(out)" ];
  installFlags = [ "INSTALL=install" ];

  installPhase = ''
    mkdir -p $out
    cp -r $src/bin $out/bin
  '';

  postFixup = ''
    wrapProgram "$out/bin/ledger2beancount" \
      --set PERL5LIB "${perlPackages.makeFullPerlPath perlDeps}"
  '';

  meta = with lib; {
    description = "Ledger to Beancount text-based converter";
    longDescription = ''
      A script to automatically convert Ledger-based textual ledgers to Beancount ones.

      Conversion is based on (concrete) syntax, so that information that is not meaningful for accounting reasons but still valuable (e.g., comments, formatting, etc.) can be preserved.
    '';
    homepage = "https://github.com/beancount/ledger2beancount";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ pablovsky ];
  };
}
