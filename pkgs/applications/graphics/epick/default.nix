{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, python3
, libGL
, libX11
, libXcursor
, libXi
, libXrandr
, libxcb
, libxkbcommon
, AppKit
, IOKit
}:

rustPlatform.buildRustPackage rec {
  pname = "epick";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "vv9k";
    repo = pname;
    rev = version;
    sha256 = "sha256-sZ0ZPst6PE6KQ+pmjqLdcD7bWU/gLRsGH84PtWTLdSQ=";
  };

  cargoSha256 = "sha256-kMVjX4AWn8XFRzI7P9NRW8B7AHcIC8TG8LQk7tzkz5o=";

  nativeBuildInputs = lib.optional stdenv.isLinux python3;

  buildInputs = lib.optionals stdenv.isLinux [
    libGL
    libX11
    libXcursor
    libXi
    libXrandr
    libxcb
    libxkbcommon
  ] ++ lib.optionals stdenv.isDarwin [
    AppKit
    IOKit
  ];

  postFixup = lib.optionalString stdenv.isLinux ''
    patchelf --set-rpath ${lib.makeLibraryPath buildInputs} $out/bin/epick
  '';

  meta = with lib; {
    description = "Simple color picker that lets the user create harmonic palettes with ease";
    homepage = "https://github.com/vv9k/epick";
    changelog = "https://github.com/vv9k/epick/blob/${version}/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ figsoda ];
  };
}
