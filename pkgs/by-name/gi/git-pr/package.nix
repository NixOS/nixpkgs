{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "git-pr";
  version = "0.0.2";

  src = fetchFromGitHub {
    owner = "picosh";
    repo = "git-pr";
    rev = "v${version}";
    hash = "sha256-7Ka8p5X8nQBXKiT6QsWOWMQJL8rePKrHz/LZU1W+oQ8=";
  };

  vendorHash = "sha256-tu5C7hz6UTgn/jCCotXzZHlUmGVNERhA7Osxi31Domk=";

  postInstall = ''
    mv $out/bin/ssh $out/bin/git-ssh
  '';

  meta = {
    homepage = "https://pr.pico.sh";
    description = "Simple git collaboration tool";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ sigmanificient ];
    mainProgram = "git-pr";
  };
}
