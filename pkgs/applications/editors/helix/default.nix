{ fetchzip, lib, rustPlatform, makeWrapper }:

rustPlatform.buildRustPackage rec {
  pname = "helix";
  version = "22.08.1";

  # This release tarball includes source code for the tree-sitter grammars,
  # which is not ordinarily part of the repository.
  src = fetchzip {
    url = "https://github.com/helix-editor/helix/releases/download/${version}/helix-${version}-source.tar.xz";
    sha256 = "sha256-pqAhUxKeFN7eebVdNN3Ge38sA30SUSu4Xn4HDZAjjyY=";
    stripRoot = false;
  };

  cargoSha256 = "sha256-idItRkymr+cxk3zv2mPBR/frCGvzEUdSAhY7gghfR3M=";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    # not needed at runtime
    rm -r runtime/grammars/sources

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
