{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
, stdenv
, pkg-config
, fontconfig
, xorg
, libxkbcommon
, wayland
, libGL
, openssl
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "inlyne";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "trimental";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Kae8WnahA/6k6QT5htYU2+diAFkmxVsbVaxRUlhf39o=";
  };

  cargoHash = "sha256-M6daK2y9HBRDV2wQjw87g1QYOqiJBfRf9uW1Eg6z6C8=";

  nativeBuildInputs = [
    installShellFiles
  ] ++ lib.optionals stdenv.isLinux [
    pkg-config
  ];

  buildInputs = lib.optionals stdenv.isLinux [
    fontconfig
    xorg.libXcursor
    xorg.libXi
    xorg.libXrandr
    xorg.libxcb
    wayland
    libxkbcommon
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk_11_0.frameworks.AppKit
  ];

  checkFlags = lib.optionals stdenv.isDarwin [
    # time out on darwin
    "--skip=interpreter::tests::centered_image_with_size_align_and_link"
    "--skip=watcher::tests::the_gauntlet"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd inlyne \
      --bash completions/inlyne.bash \
      --fish completions/inlyne.fish \
      --zsh completions/_inlyne
  '';

  postFixup = lib.optionalString stdenv.isLinux ''
    patchelf $out/bin/inlyne \
      --add-rpath ${lib.makeLibraryPath [ libGL xorg.libX11 ]}
  '';

  meta = with lib; {
    description = "GPU powered browserless markdown viewer";
    homepage = "https://github.com/trimental/inlyne";
    changelog = "https://github.com/trimental/inlyne/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "inlyne";
  };
}
