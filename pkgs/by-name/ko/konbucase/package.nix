{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, vala
, pkg-config
, wrapGAppsHook
, pantheon
, gtksourceview5
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "konbucase";
  version = "4.1.1";

  src = fetchFromGitHub {
    owner = "ryonakano";
    repo = "konbucase";
    rev = finalAttrs.version;
    hash = "sha256-g3EDa9EXymi6c8dRHFZYGEAT7k8M2TXUAzZVKTnLzyk=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    meson
    ninja
    vala
    pkg-config
    wrapGAppsHook
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

  meta = with lib; {
    homepage = "https://github.com/ryonakano/konbucase";
    description = "A case converting app suitable for coding or typing";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ galaxy ];
    platforms = platforms.linux;
    mainProgram = "konbucase";
  };
})
