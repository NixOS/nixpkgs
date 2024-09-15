{ fetchzip, lib, rustPlatform, git, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "helix";
  version = "24.07";

  # This release tarball includes source code for the tree-sitter grammars,
  # which is not ordinarily part of the repository.
  src = fetchzip {
    url = "https://github.com/helix-editor/helix/releases/download/${version}/helix-${version}-source.tar.xz";
    hash = "sha256-R8foMx7YJ01ZS75275xPQ52Ns2EB3OPop10F4nicmoA=";
    stripRoot = false;
  };

  cargoHash = "sha256-Y8zqdS8vl2koXmgFY0hZWWP1ZAO8JgwkoPTYPVpkWsA=";

  nativeBuildInputs = [ git installShellFiles ];

  env.HELIX_DEFAULT_RUNTIME = "${placeholder "out"}/lib/runtime";

  postInstall = ''
    # not needed at runtime
    rm -r runtime/grammars/sources

    mkdir -p $out/lib
    cp -r runtime $out/lib
    installShellCompletion contrib/completion/hx.{bash,fish,zsh}
    mkdir -p $out/share/{applications,icons/hicolor/256x256/apps}
    cp contrib/Helix.desktop $out/share/applications
    cp contrib/helix.png $out/share/icons/hicolor/256x256/apps
  '';

  meta = with lib; {
    description = "Post-modern modal text editor";
    homepage = "https://helix-editor.com";
    license = licenses.mpl20;
    mainProgram = "hx";
    maintainers = with maintainers; [ danth yusdacra zowoq ];
  };
}
