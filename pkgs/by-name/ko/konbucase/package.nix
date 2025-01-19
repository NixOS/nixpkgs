{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  vala,
  pkg-config,
  wrapGAppsHook3,
  pantheon,
  gtksourceview5,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "konbucase";
  version = "4.1.2";

  src = fetchFromGitHub {
    owner = "ryonakano";
    repo = "konbucase";
    rev = finalAttrs.version;
    hash = "sha256-md7drxg1JuW6TRJauKOk4Aqjx/V1RVZ+POa5v6DtKwk=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    meson
    ninja
    vala
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    pantheon.granite7
    gtksourceview5
  ];

  postInstall = ''
    mv $out/bin/com.github.ryonakano.konbucase $out/bin/konbucase
    substituteInPlace $out/share/applications/com.github.ryonakano.konbucase.desktop \
      --replace 'Exec=com.github.ryonakano.konbucase' 'Exec=${placeholder "out"}/bin/konbucase'
  '';

  meta = {
    homepage = "https://github.com/ryonakano/konbucase";
    description = "Case converting app suitable for coding or typing";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ galaxy ];
    platforms = lib.platforms.linux;
    mainProgram = "konbucase";
  };
})
