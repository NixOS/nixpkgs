{ lib
, stdenv
, fetchFromGitHub
, makeBinaryWrapper
, meson
, ninja
, pkg-config
, vala
, wrapGAppsHook
, gocryptfs
, gtk3
, json-glib
, libgee
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cryptor";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "moson-mo";
    repo = "cryptor";
    rev = "v${finalAttrs.version}";
    hash = "sha256-bgOOueOKSc6dLyxGU+ds9XYWM5mO+qCKC4dkCu2B1sQ=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    json-glib
    libgee
  ];

  postInstall = ''
    wrapProgram $out/bin/cryptor \
      --prefix PATH : "${lib.makeBinPath [ gocryptfs ]}"
  '';

  meta = {
    description = "Simple gocryptfs GUI";
    homepage = "https://github.com/moson-mo/cryptor";
    license = lib.licenses.bsd3;
    mainProgram = "cryptor";
    maintainers = with lib.maintainers; [ fgaz ];
    platforms = lib.platforms.all;
  };
})
