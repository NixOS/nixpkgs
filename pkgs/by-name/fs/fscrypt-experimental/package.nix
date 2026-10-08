{
  lib,
  buildGoModule,
  fetchFromGitHub,
  gnum4,
  pam,
  fscrypt-experimental,
}:

# Don't use this for anything important yet!

buildGoModule rec {
  pname = "fscrypt";
  version = "0.3.7";

  src = fetchFromGitHub {
    owner = "google";
    repo = "fscrypt";
    rev = "v${version}";
    hash = "sha256-3Xz5ro+V2mfSVqiS7RcB4QH3Whv/XaMLCiUc50bAKf0=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace 'TAG_VERSION := $(shell git describe --tags)' "" \
      --replace "/usr/local" "$out"
  '';

  vendorHash = "sha256-lR3qcRSVQjxyBuqHv5warfVVJy5zdomfE0DEJbA/RkQ=";

  doCheck = false;

  nativeBuildInputs = [ gnum4 ];
  buildInputs = [ pam ];

  buildPhase = ''
    runHook preBuild
    make
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    make install
    runHook postInstall
  '';

  meta = {
    description = "High-level tool for the management of Linux filesystem encryption";
    mainProgram = "fscrypt";
    longDescription = ''
      This tool manages metadata, key generation, key wrapping, PAM integration,
      and provides a uniform interface for creating and modifying encrypted
      directories.
    '';
    inherit (src.meta) homepage;
    changelog = "https://github.com/google/fscrypt/releases/tag/v${version}";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
}
