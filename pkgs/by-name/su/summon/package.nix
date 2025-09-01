{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "summon";
  version = "0.10.5";

  src = fetchFromGitHub {
    owner = "cyberark";
    repo = "summon";
    rev = "v${version}";
    hash = "sha256-m4aLGEUXBakfp+KwUZBmNzFEHuG58ZuWQFF5TmUM7pM=";
  };

  vendorHash = "sha256-QOCPATTs2vvww+ekt6HFg2IUA/NFmE8+2WkMby2f/OE=";

  subPackages = [ "cmd" ];

  postInstall = ''
    mv $out/bin/cmd $out/bin/summon
  '';

  meta = with lib; {
    description = "CLI that provides on-demand secrets access for common DevOps tools";
    mainProgram = "summon";
    homepage = "https://cyberark.github.io/summon";
    license = lib.licenses.mit;
    maintainers = with maintainers; [ quentini ];
  };
}
