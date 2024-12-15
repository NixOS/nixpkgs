{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "pkgtop";
  version = "2.5.1";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = "pkgtop";
    rev = version;
    hash = "sha256-NY8nx4BKAUq1nGBlzRzm2OH1k01TV6qs2IcoErhuxTc=";
  };

  vendorHash = "sha256-dlDbNym7CNn5088znMNgGAr2wBM3+nYv3q362353aLs=";

  postInstall = ''
    mv $out/bin/{cmd,pkgtop}
  '';

  meta = with lib; {
    description = "Interactive package manager and resource monitor designed for the GNU/Linux";
    homepage = "https://github.com/orhun/pkgtop";
    changelog = "https://github.com/orhun/pkgtop/releases/tag/${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "pkgtop";
  };
}
