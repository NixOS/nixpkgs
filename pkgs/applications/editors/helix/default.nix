{ fetchFromGitHub, lib, rustPlatform, makeWrapper }:

rustPlatform.buildRustPackage rec {
  pname = "helix";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "helix-editor";
    repo = pname;
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "sha256-iCNA+gZer6BycWnhosDFRuxfS6QAb06XTix/vFsaey0=";
  };

  cargoSha256 = "sha256-sqXPgtLMXa3kMQlnw2xDBEsVfjeRXO6Zp6NEFS/0h20=";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    mkdir -p $out/lib
    cp -r runtime $out/lib
  '';
  postFixup = ''
    wrapProgram $out/bin/hx --set HELIX_RUNTIME $out/lib/runtime
  '';

  meta = with lib; {
    description = "A post-modern modal text editor";
    homepage = "https://helix-editor.com";
    license = licenses.mpl20;
    mainProgram = "hx";
    maintainers = with maintainers; [ yusdacra ];
  };
}
