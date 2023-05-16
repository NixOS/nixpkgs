<<<<<<< HEAD
{ fetchpatch, fetchzip, lib, rustPlatform, git, installShellFiles, makeWrapper }:

rustPlatform.buildRustPackage rec {
  pname = "helix";
  version = "23.05";
=======
{ fetchzip, lib, rustPlatform, installShellFiles, makeWrapper }:

rustPlatform.buildRustPackage rec {
  pname = "helix";
  version = "23.03";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # This release tarball includes source code for the tree-sitter grammars,
  # which is not ordinarily part of the repository.
  src = fetchzip {
    url = "https://github.com/helix-editor/helix/releases/download/${version}/helix-${version}-source.tar.xz";
<<<<<<< HEAD
    hash = "sha256-3ZEToXwW569P7IFLqz6Un8rClnWrW5RiYKmRVFt7My8=";
    stripRoot = false;
  };

  cargoHash = "sha256-/LCtfyDAA2JuioBD/CDMv6OOxM0B9A3PpuVP/YY5oF0=";

  patches = [
    (fetchpatch {
      url = "https://patch-diff.githubusercontent.com/raw/helix-editor/helix/pull/7227.patch";
      hash = "sha256-dObMKHNJfc5TODUjZ28TVxuTen02rl8HzcXpFWnhB1k=";
    })
  ];

  nativeBuildInputs = [ git installShellFiles makeWrapper ];
=======
    hash = "sha256-FtY2V7za3WGeUaC2t2f63CcDUEg9zAS2cGUWI0YeGwk=";
    stripRoot = false;
  };

  # should be removed, when tree-sitter is not used as a git checkout anymore
  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "tree-sitter-0.20.9" = "sha256-/PaFaASOT0Z8FpipX5uiRCjnv1kyZtg4B9+TnHA0yTY=";
    };
  };

  nativeBuildInputs = [ installShellFiles makeWrapper ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
<<<<<<< HEAD
    maintainers = with maintainers; [ danth yusdacra zowoq ];
=======
    maintainers = with maintainers; [ danth yusdacra ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
