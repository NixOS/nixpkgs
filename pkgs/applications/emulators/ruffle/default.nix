{ alsa-lib
, fetchFromGitHub
, makeWrapper
, openssl
, pkg-config
, python3
, rustPlatform
, lib
, wayland
, xorg
, vulkan-loader
}:

rustPlatform.buildRustPackage rec {
  pname = "ruffle";
  version = "nightly-2022-02-02";

  src = fetchFromGitHub {
    owner = "ruffle-rs";
    repo = pname;
    rev = version;
    sha256 = "sha256-AV3zGfWacYdkyxHED1nGwTqRHhXpybaCVnudmHqWvqw=";
  };

  nativeBuildInputs = [
    makeWrapper
    pkg-config
    python3
  ];

  buildInputs = [
    alsa-lib
    openssl
    wayland
    xorg.libX11
    xorg.libXcursor
    xorg.libXrandr
    xorg.libXi
    xorg.libxcb
    xorg.libXrender
    vulkan-loader
  ];

  postInstall = ''
    # This name is too generic
    mv $out/bin/exporter $out/bin/ruffle_exporter

    wrapProgram $out/bin/ruffle_desktop --prefix LD_LIBRARY_PATH ':' ${vulkan-loader}/lib
  '';

  cargoSha256 = "sha256-LP9aHcey+e3fqtWdOkqF5k8dwjdAOKpP+mKGxFhTte0=";

  meta = with lib; {
    description = "An Adobe Flash Player emulator written in the Rust programming language.";
    homepage = "https://ruffle.rs/";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ govanify ];
    platforms = platforms.linux;
  };
}
