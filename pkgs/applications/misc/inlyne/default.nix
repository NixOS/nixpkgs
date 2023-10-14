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
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "trimental";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-B+H3G4jVysqrzWIP+1hktSGnycZLizxhmBCO/lYIr0I=";
  };

  cargoHash = "sha256-LFL2DVKu/UM7effikZN/IhSD6DrlwO+CF+S60PXULa0=";

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
