{ fetchFromGitHub, lib, rustPlatform, makeWrapper }:

rustPlatform.buildRustPackage rec {
  pname = "helix";
  version = "22.03";

  src = fetchFromGitHub {
    owner = "helix-editor";
    repo = pname;
    rev = version;
    fetchSubmodules = true;
    sha256 = "anUYKgr61QQmdraSYpvFY/2sG5hkN3a2MwplNZMEyfI=";
  };

  cargoSha256 = "zJQ+KvO+6iUIb0eJ+LnMbitxaqTxfqgu7XXj3j0GiX4=";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    mkdir -p $out/lib
    cp -r runtime $out/lib
  '';
  postFixup = ''
    wrapProgram $out/bin/hx --set HELIX_RUNTIME $out/lib/runtime
  '';

  # This tries to fetch the tree-sitter grammars over the Internet:
  # https://github.com/helix-editor/helix/blob/f8c83f98859fd618980141eb95e7927dcdf074d7/helix-loader/src/grammar.rs#L140-L185
  # TODO: Download the grammars through Nix so that they can be enabled.
  HELIX_DISABLE_AUTO_GRAMMAR_BUILD = true;

  meta = with lib; {
    description = "A post-modern modal text editor";
    homepage = "https://helix-editor.com";
    license = licenses.mpl20;
    mainProgram = "hx";
    maintainers = with maintainers; [ danth yusdacra ];
  };
}
