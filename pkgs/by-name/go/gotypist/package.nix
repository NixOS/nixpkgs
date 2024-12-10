{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gotypist";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "pb-";
    repo = "gotypist";
    rev = version;
    sha256 = "0khl2f6bl121slw9mlf4qzsdarpk1v3vry11f3dvz7pb1q6zjj11";
  };

  vendorHash = null;

  meta = with lib; {
    description = "Touch-typing tutor";
    mainProgram = "gotypist";
    longDescription = ''
      A simple touch-typing tutor that follows Steve Yegge's methodology of
      going in fast, slow, and medium cycles.
    '';
    homepage = "https://github.com/pb-/gotypist";
    license = licenses.mit;
    maintainers = with maintainers; [ pb- ];
  };
}
