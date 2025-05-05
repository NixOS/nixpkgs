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
  version = "202008-unstable-2025-03-11";

  src = fetchFromGitHub {
    owner = "PaulCombal";
    repo = "SamRewritten";
    # The latest release is too old, use latest commit instead
    rev = "cac0291f3e4465135f5cf7d5b99fdb005fb23ade";
    hash = "sha256-+f/j2q1lJ3yp3/BBgnK9kS4P3ULQ5onQPAcUV12LYnI=";
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
