{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "summon";
  version = "0.10.7";

  src = fetchFromGitHub {
    owner = "cyberark";
    repo = "summon";
    rev = "v${version}";
    hash = "sha256-BUT8pCLfhss3OgB3JN2lEZTXzyT607ABn6/2g01jxbM=";
  };

  vendorHash = "sha256-ZT3lVL8qoonmeWsmCzjMbOsAf2NvpheC6ThDzn4izkU=";

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
