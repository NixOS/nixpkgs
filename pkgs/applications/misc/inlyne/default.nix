{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
, stdenv
, pkg-config
, fontconfig
, xorg
, libGL
, openssl
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "inlyne";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "trimental";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-DSi6iS1ySdvGf6FxZpsDOAFpAKx/APcZjxA3Qy0gQBU=";
  };

  cargoHash = "sha256-UzegSJGAOBUDN8WluN7fLWS7NfHhm9YY0Zuq6DCIqHo=";

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
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk_11_0.frameworks.AppKit
  ];

  checkFlags = lib.optionals stdenv.isDarwin [
    # time out on darwin
    "--skip=interpreter::tests::centered_image_with_size_align_and_link"
    "--skip=watcher::tests::the_gauntlet"
  ];

  postInstall = ''
    installShellCompletion --cmd inlyne \
      --bash <($out/bin/inlyne --gen-completions bash) \
      --fish <($out/bin/inlyne --gen-completions fish) \
      --zsh <($out/bin/inlyne --gen-completions zsh)
  '';

  postFixup = lib.optionalString stdenv.isLinux ''
    patchelf $out/bin/inlyne \
      --add-rpath ${lib.makeLibraryPath [ libGL xorg.libX11 ]}
  '';

  meta = with lib; {
    description = "A GPU powered browserless markdown viewer";
    homepage = "https://github.com/trimental/inlyne";
    changelog = "https://github.com/trimental/inlyne/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
