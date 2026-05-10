{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gnome-themes-extra,
  gtk-engine-murrine,
  jdupes,
  sassc,
}:

stdenvNoCC.mkDerivation rec {
  pname = "everforest-gtk-theme";
  version = "0-unstable-2025-10-23";

  src = fetchFromGitHub {
    owner = "Fausto-Korpsvart";
    repo = "Everforest-GTK-Theme";
    rev = "9b8be4d6648ae9eaae3dd550105081f8c9054825";
    hash = "sha256-XHO6NoXJwwZ8gBzZV/hJnVq5BvkEKYWvqLBQT00dGdE=";
  };

  propagatedUserEnvPkgs = [
    gtk-engine-murrine
  ];

  nativeBuildInputs = [
    jdupes
    sassc
  ];

  buildInputs = [
    gnome-themes-extra
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    pushd themes/release
    patchShebangs make-release.sh
    # don't run last line of make-release.sh
    # that packs all the theme variants into tarballs
    sed -i '$d' make-release.sh
    ./make-release.sh
    # fix theme names to start with Everforest-
    # rather than pname and version
    for f in "${pname}-${version}-"*; do
      mv "$f" "Everforest-''${f#${pname}-${version}-}"
    done
    popd

    mkdir -p "$out/share/"{themes,icons}
    cp -a icons/* "$out/share/icons/"
    mv themes/release/Everforest* "$out/share/themes/"

    # hard link when possible
    jdupes -L -r $out/share

    runHook postInstall
  '';

  meta = {
    description = "Everforest colour palette for GTK";
    homepage = "https://github.com/Fausto-Korpsvart/Everforest-GTK-Theme";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      jn-sena
      elnudev
    ];
    platforms = lib.platforms.unix;
  };
}
