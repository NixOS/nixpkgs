{ fetchpatch, fetchzip, lib, rustPlatform, git, installShellFiles, makeWrapper }:

rustPlatform.buildRustPackage rec {
  pname = "helix";
  version = "23.10";

  # This release tarball includes source code for the tree-sitter grammars,
  # which is not ordinarily part of the repository.
  src = fetchzip {
    url = "https://github.com/helix-editor/helix/releases/download/${version}/helix-${version}-source.tar.xz";
    hash = "sha256-PH4n+zm5ShwOrzzQm0Sn8b8JzAW/CF8UzzKZYE3e2WA=";
    stripRoot = false;
  };

  patches = [
    # Fixes implicit int error in rescript grammar when building with clang 16.
    # https://github.com/nkrkv/tree-sitter-rescript/pull/227.
    (fetchpatch {
      url = "https://github.com/nkrkv/tree-sitter-rescript/commit/ea93cbf7d9c52f925ed296b4714737e8088f3a19.patch";
      hash = "sha256-gpGPiy+yEs+dMJEnE5O3WC7iSB/6PLJYBYRcdTx//+o=";
      extraPrefix = "runtime/grammars/sources/rescript/";
      stripLen = 1;
    })
  ];

  cargoHash = "sha256-B8RO6BADDbPchowSfNVgviGvVgH23iF42DdhEBKBQzs=";

  nativeBuildInputs = [ git installShellFiles makeWrapper ];

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
  postFixup = ''
    wrapProgram $out/bin/hx --set HELIX_RUNTIME $out/lib/runtime
  '';

  meta = with lib; {
    description = "A post-modern modal text editor";
    homepage = "https://helix-editor.com";
    license = licenses.mpl20;
    mainProgram = "hx";
    maintainers = with maintainers; [ danth yusdacra zowoq ];
  };
}
