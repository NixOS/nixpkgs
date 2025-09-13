{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchpatch,
  cmake,
  pkg-config,
  opencv,
  curl,
  mbedtls,
  glm,
  nlohmann_json,
  crow,
  glib,
  pipewire,
  libsysprof-capture,
  pcre2,
  util-linux,
  libselinux,
  libsepol,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "huenicorn";
  version = "1.0.11";

  src = fetchFromGitLab {
    owner = "openjowelsofts";
    repo = "huenicorn";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OoAc1TtJT9BzoPHzTEtDEsLcaSS/nIf5WJDz7BA+d0k=";
  };

  patches = [
    (fetchpatch {
      url = "https://gitlab.com/openjowelsofts/huenicorn/-/commit/5d5a8c72dfb3e2986aac685acade30f8367e2a0f.patch";
      sha256 = "sha256-IPKHLh5F5A5nAYzA2ZsnF9OELsBSfeIM/UxcOcs+kME=";
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    opencv
    curl
    mbedtls
    glm
    nlohmann_json
    crow
    glib
    pipewire

    # builds without these, but cmake complains
    libsysprof-capture
    pcre2
    util-linux
    libselinux
    libsepol
  ];

  installPhase = ''
    runHook preInstall

    install -D huenicorn --target-directory=$out/bin

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Linux Ambilight driver for Philips Hue™ devices";
    homepage = "https://gitlab.com/openjowelsofts/huenicorn";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ XBagon ];
    mainProgram = "huenicorn";
    platforms = lib.platforms.all;
  };
})
