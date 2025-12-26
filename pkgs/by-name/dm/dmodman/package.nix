{
  lib,
  fetchFromGitHub,
  fetchpatch,
  openssl,
  pkg-config,
  rustPlatform,
  nxmUrlHandler ? true,
}:

rustPlatform.buildRustPackage rec {
  pname = "dmodman";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "dandels";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-SpfQzL9bFW/hvYSTBy+sI8FsywbohyvT2ZgpMl6KuEg=";
  };

  patches = [
    # fix test that broke when a field became optional
    (fetchpatch {
      url = "https://github.com/dandels/dmodman/commit/dad568ddc121172c47807dcb39534becaba98684.diff";
      hash = "sha256-W/XlYYtT0vr1QjSixG75Q+Y+XNjOK6jSqvBMB1qbqvk=";
    })
  ];

  cargoHash = "sha256-ecchFPJBVsJZZ5rVYsjiJUrgm3rBdO+iU8JtuQ4PTN0=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  postInstall = lib.optionalString nxmUrlHandler ''
    install -Dm 644 dmodman.desktop out/share/applications/
  '';

  meta = {
    description = "TUI downloader and update checker for Nexusmods.com";
    homepage = "https://github.com/dandels/dmodman";
    license = lib.licenses.mit;
    mainProgram = "dmodman";
    maintainers = [ lib.maintainers.schnusch ];
  };
}
