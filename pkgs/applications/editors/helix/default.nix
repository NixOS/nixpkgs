{ fetchzip, lib, rustPlatform, makeWrapper }:

rustPlatform.buildRustPackage rec {
  pname = "helix";
  version = "22.03";

  # This release tarball includes source code for the tree-sitter grammars,
  # which is not ordinarily part of the repository.
  src = fetchzip {
    url = "https://github.com/helix-editor/helix/releases/download/${version}/helix-${version}-source.tar.xz";
    sha256 = "DP/hh6JfnyHdW2bg0cvhwlWvruNDvL9bmXM46iAUQzA=";
    stripRoot = false;
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

  meta = with lib; {
    description = "A post-modern modal text editor";
    homepage = "https://helix-editor.com";
    license = licenses.mpl20;
    mainProgram = "hx";
    maintainers = with maintainers; [ danth yusdacra ];
  };
}
