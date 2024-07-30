{ lib
, stdenvNoCC
, fetchFromGitHub
, testers
, ruby
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "rsmangler";
  version = "1.5-unstable-2019-07-24";

  src = fetchFromGitHub {
    owner = "digininja";
    repo = "RSMangler";
    rev = "e85da7d4a6e6241a92389aecf376077adc7544c3";
    hash = "sha256-DN20XzrlkunLyk4nkgytUJEtCOlFjWUUUAQ416l3Aug=";
  };

  buildInputs = [ ruby ];

  postPatch = ''
    substituteInPlace rsmangler.rb \
      --replace-quiet ./rsmangler.rb rsmangler \
      --replace-quiet rsmangler.rb rsmangler
  '';

  postInstall = ''
    install -Dm555 rsmangler.rb $out/bin/rsmangler
  '';

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    command = "rsmangler --help";
    version = "rsmangler v ${lib.versions.majorMinor finalAttrs.version}";
  };

  meta = with lib; {
    description = "Perform various manipulations on the wordlists";
    homepage = "https://github.com/digininja/RSMangler";
    license = licenses.cc-by-sa-20;
    mainProgram = "rsmangler";
    maintainers = with maintainers; [ d3vil0p3r ];
    platforms = ruby.meta.platforms;
  };
})
