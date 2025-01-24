{
  lib,
  stdenv,
  fetchFromGitHub,
  unstableGitUpdater,
  curl,
  gtkmm3,
  glibmm,
  gnutls,
  yajl,
  pkg-config,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "samrewritten";
  version = "202008-unstable-2025-01-09";

  src = fetchFromGitHub {
    owner = "PaulCombal";
    repo = "SamRewritten";
    # The latest release is too old, use latest commit instead
    rev = "b18a009c20eb90e2edffb6ee6d5290c86c860e03";
    hash = "sha256-qwasSxNc4hJDadGTUOxzumJ4lZcHQ4Aa8W8jIJAvTt4=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    curl
    gtkmm3
    glibmm
    gnutls
    yajl
  ];

  postInstall = ''
    substituteInPlace $out/share/applications/samrewritten.desktop \
      --replace-fail "Exec=/usr/bin/samrewritten" "Exec=samrewritten"
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Steam Achievement Manager For Linux. Rewritten in C++";
    mainProgram = "samrewritten";
    homepage = "https://github.com/PaulCombal/SamRewritten";
    changelog = "https://github.com/PaulCombal/SamRewritten/releases";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ludovicopiero ];
    platforms = [ "x86_64-linux" ];
  };
})
