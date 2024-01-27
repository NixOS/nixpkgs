{ lib
, fetchFromGitHub
, stdenv
, rustPlatform
, just
, pkg-config
, makeBinaryWrapper
, libxkbcommon
, wayland
}:

rustPlatform.buildRustPackage rec {
  pname = "cosmic-applibrary";
  version = "unstable-2024-01-03";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = pname;
    rev = "889cb6078c05cdf3eb94f19f64db552fa2be32dc";
    hash = "sha256-qLAFSHA7YdOWr7ZmLCkQ+aGWb2schANfgdD2BxsrvaE=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.11.0" = "sha256-xVhe6adUb8VmwIKKjHxwCwOo5Y1p3Or3ylcJJdLDrrE=";
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "cosmic-config-0.1.0" = "sha256-WM08/jnB2kAf77FE+0xpBJcVGOHOCcUorifQ/5LXav0=";
      "cosmic-client-toolkit-0.1.0" = "sha256-AEgvF7i/OWPdEMi8WUaAg99igBwE/AexhAXHxyeJMdc=";
      "glyphon-0.3.0" = "sha256-JGkNIfj1HjOF8kGxqJPNq/JO+NhZD6XrZ4KmkXEP6Xc=";
      "smithay-client-toolkit-0.18.0" = "sha256-2WbDKlSGiyVmi7blNBr2Aih9FfF2dq/bny57hoA4BrE=";
      "softbuffer-0.3.3" = "sha256-eKYFVr6C1+X6ulidHIu9SP591rJxStxwL9uMiqnXx4k=";
      "taffy-0.3.11" = "sha256-SCx9GEIJjWdoNVyq+RZAGn0N71qraKZxf9ZWhvyzLaI=";
      "cosmic-settings-daemon-0.1.0" = "sha256-z/dvRyc3Zc1fAQh2HKk6NI6QSDpNqarqslwszjU+0nc=";
      "cosmic-text-0.10.0" = "sha256-C2FHJBESbiyL2BhLb6T+wI9EX+xCyp02Kk6cI46EfDs=";
    };
  };

  nativeBuildInputs = [ just pkg-config makeBinaryWrapper ];
  buildInputs = [ libxkbcommon wayland ];

  dontUseJustBuild = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-app-library"
  ];

  postPatch = ''
    substituteInPlace justfile --replace '#!/usr/bin/env' "#!$(command -v env)"
  '';

  postInstall = ''
    wrapProgram $out/bin/cosmic-app-library \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [wayland]}"
  '';

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-applibrary";
    description = "Application Template for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ nyanbinary ];
    platforms = platforms.linux;
    mainProgram = "cosmic-app-library";
  };
}
