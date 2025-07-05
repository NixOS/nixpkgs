{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "summon";
  version = "0.10.4";

  src = fetchFromGitHub {
    owner = "cyberark";
    repo = "summon";
    rev = "v${version}";
    hash = "sha256-nAjaZh0bnGBZh2wK78M4gg8BGsM6kBQ8MNvfPI7TIOg=";
  };

  vendorHash = "sha256-B6sbMKmuIQ+xoJspFCRtqe9IOLW+AFF5XQBDSLhM9cI=";

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
